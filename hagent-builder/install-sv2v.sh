#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install yosys dependencies
apt-get install -y haskell-stack

cd /tmp
git clone https://github.com/zachjs/sv2v.git
cd sv2v
make
cp bin/sv2v /usr/local/bin/
cd /tmp/
rm -rf /tmp/sv2v
