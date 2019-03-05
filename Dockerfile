# alpine:3.7
FROM bitwalker/alpine-elixir:1.8.0

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2019-03-05 \
    # Set this so that CTRL+G works properly
    TERM=xterm

RUN \
    mkdir -p /opt/app \
    && chmod -R 777 /opt/app \
    && apk update \
    && apk --no-cache --update add git make g++ wget curl inotify-tools yarn \
    && rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:/opt/.yarn/bin:$PATH \
    MIX_HOME=/opt/mix \
    HEX_HOME=/opt/hex \
    HOME=/opt/app

# Install Hex+Rebar
RUN mix local.hex --force && mix local.rebar --force

WORKDIR /opt/app

CMD ["/bin/sh"]
