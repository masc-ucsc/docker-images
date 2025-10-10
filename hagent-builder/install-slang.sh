#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

git clone https://github.com/MikePopoloski/slang.git /tmp/slang
cd /tmp/slang
cmake -B build
cmake --build build -j
cd build
make install
rm -rf /tmp/slang
