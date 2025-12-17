#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install yosys dependencies
apt-get install -y lld bison flex libffi-dev libfl-dev pkg-config zlib1g-dev graphviz

# Install yosys
cd /tmp
curl -L -o /tmp/yosys.tar.gz https://github.com/YosysHQ/yosys/releases/download/v0.60/yosys.tar.gz
mkdir /tmp/yosys
cd /tmp/yosys
tar xzf ../yosys.tar.gz
make config-gcc
make -j 16
make install
rm -rf /tmp/yosys*

# Install yosys-slang plugin
cd /tmp
git clone --recursive https://github.com/povik/yosys-slang /tmp/yosys-slang
mkdir /tmp/yosys-slang/build
cd /tmp/yosys-slang/build
cmake ..
make -j 16
make install
rm -rf /tmp/yosys-slang

# Install sv2v that sometimes yosys needs
# apt install -y haskell-stack
# cd /tmp
# git clone https://github.com/zachjs/sv2v.git
# cd sv2v
# make
# cp bin/sv2v /usr/local/bin/
# cd /tmp/
# rm -rf /tmp/sv2v
