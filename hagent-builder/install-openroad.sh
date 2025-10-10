#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Packages needed for openroad
RUN add-apt-repository -y ppa:deadsnakes/ppa &&
  apt-get install -y python3.10 python3.10-venv python3.10-dev libqt5gui5t64 libqt5charts5 tcl-tclreadline

git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git /tmp/openroad
cd /tmp/openroad
./etc/DependencyInstaller.sh -base
./etc/DependencyInstaller.sh -common
./etc/Build.sh -no-tests
cd build
make install
rm -rf /tmp/openroad
