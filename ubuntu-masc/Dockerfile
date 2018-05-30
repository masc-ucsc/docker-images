FROM ubuntu:rolling

RUN apt-get update

# Packages for most tools
RUN apt-get install --no-install-recommends -y ca-certificates build-essential git gcc g++ clang llvm liblld-6.0-dev curl gnupg

# Python/ruby packages
RUN apt-get install --no-install-recommends -y python3-setuptools python3-dev python3-pip ruby

# Packages for esesc
RUN apt-get install --no-install-recommends -y libboost-dev cmake flex bison libpixman-1-dev libbz2-dev
RUN apt-get install --no-install-recommends -y libsdl2-dev python2.7 libncurses5-dev libncursesw5-dev

# Packages for lgraph
RUN ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN echo "America/Los_Angeles" > /etc/timezone
RUN apt-get install --no-install-recommends -y tclcl-dev mercurial gawk libreadline-dev
RUN apt-get install --no-install-recommends -y tcl tcl-dev tk-dev rapidjson-dev libffi-dev
RUN apt-get install --no-install-recommends -y libboost-all-dev

# Packages for Pyrope
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs npm yarn

# cryptominisat needed by lgraph
WORKDIR /root
RUN git clone https://github.com/msoos/cryptominisat.git
WORKDIR /root/cryptominisat
RUN git submodule update --init
WORKDIR /root/cryptominisat/build
RUN cmake .. \
 && make -j2 \
 && make install \
 && ldconfig

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

