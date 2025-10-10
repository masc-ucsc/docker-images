#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install yosys dependencies
apt-get install -y flex bison autoconf sqlite3 libsqlite3-dev libzstd-dev libreadline6-dev libsdl2-dev zlib1g-dev

# Install yosys
cd /tmp
curl -L -o /tmp/yosys.tar.gz https://github.com/YosysHQ/yosys/releases/download/v0.57/yosys.tar.gz
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
