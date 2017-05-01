cd vendor
git clone git@github.com:rrrene/credo.git
git clone https://github.com/rrrene/bunt
cd .. && docker build -t webdeb/phx .
