#FROM ubuntu:rolling
FROM ubuntu:bionic
#FROM ubuntu:latest  # May be better (must be for gems)

RUN apt-get update

# Packages for most tools
RUN apt-get upgrade --no-install-recommends -y
RUN apt-get install --no-install-recommends -y ca-certificates build-essential git gcc g++ clang llvm liblld-6.0-dev curl gnupg

# To avoid questions on timezome
RUN ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN echo "America/Los_Angeles" > /etc/timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Python/ruby packages
#RUN apt-get install --no-install-recommends -y python3-setuptools python3-dev python3-pip ruby

# Packages for esesc
RUN apt-get install --no-install-recommends -y libboost-dev cmake flex bison libpixman-1-dev libbz2-dev
RUN apt-get install --no-install-recommends -y libsdl2-dev python2.7 libncurses5-dev libncursesw5-dev

# Packages for gem5
#RUN apt-get install --no-install-recommends -y python-six m4 scons zlib1g zlib1g-dev libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev python-dev python

# Packages for livehd (needs gcc 8 or newer)
RUN apt-get install -y g++-8 clang-8
RUN apt-get install --no-install-recommends -y tclcl-dev mercurial gawk libreadline-dev ruby
RUN apt-get install --no-install-recommends -y tcl tcl-dev tk-dev rapidjson-dev libffi-dev
RUN apt-get install --no-install-recommends -y libboost-all-dev
#RUN pip3 install ptpython

# Packages for Pyrope
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update
#RUN apt-get install --no-install-recommends -y nodejs npm yarn

# cryptominisat needed by lgraph
#WORKDIR /root
#RUN git clone https://github.com/msoos/cryptominisat.git
#WORKDIR /root/cryptominisat
#RUN git submodule update --init
#WORKDIR /root/cryptominisat/build
#RUN cmake .. \
 #&& make -j2 \
 #&& make install \
 #&& ldconfig

# Yosys
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
WORKDIR /root/yosys
RUN make config-clang \
 && make -j$(nproc) \
 && make install
RUN rm -rf /root/yosys

#bazel
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add - \
 && echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
 && apt-get update && apt install --no-install-recommends -y bazel

# Packages for debugging when the image fails
#RUN apt-get install --no-install-recommends -y vim gdb

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup to save some space
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

