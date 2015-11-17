FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  bison \
  build-essential \
  cmake \
  flex \
  g++ \
  libaio-dev \
  libboost-dev \
  libbz2-dev \
  libcrypto++-dev \
  libcurl4-openssl-dev \
  libepoxy-dev  \
  libgles2-mesa-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libnuma-dev \
  libpixman-1-dev \
  libsdl1.2-dev \
  libssh2-1-dev \
  libvte-dev \
  libseccomp-dev \
  python \
  uuid-dev \
  zlib1g-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Test edit to see if this triggers build
