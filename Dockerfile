FROM bitwalker/alpine-elixir:latest
MAINTAINER Boris Kotov <bk@webdeb.de>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2017-01-12 \
    # Set this so that CTRL+G works properly
    TERM=xterm

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH \
    HOME=/opt

# Install NPM
RUN \
    mkdir -p /opt/app \
    && chmod -R 777 /opt/app \
    && apk update \
    && apk --no-cache --update add \
      git make g++ wget curl inotify-tools nodejs \
    && npm install npm -g --no-progress \
    && curl -o- -L https://yarnpkg.com/install.sh | sh \
    && update-ca-certificates --fresh \
    && rm -rf /var/cache/apk/*


# Install Hex+Rebar
RUN mix local.hex --force \
    && mix local.rebar --force

COPY vendor /vendor

# Install credo standalone
RUN cd /vendor/credo \
    && mix deps.get \
    && mix archive.build \
    && mix archive.install --force

# Install bunt
RUN cd /vendor/bunt \
    && mix archive.build \
    && mix archive.install --force

ENV PATH /opt/.yarn/bin:$PATH

WORKDIR /opt/app

CMD ["/bin/sh"]
