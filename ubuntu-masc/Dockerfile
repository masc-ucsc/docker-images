FROM ubuntu:rolling

RUN apt-get update

# Packages for most tools
RUN apt-get install --no-install-recommends -y ca-certificates build-essential git gcc g++ clang llvm liblld-6.0-dev curl gnupg

# Python/ruby packages
#RUN apt-get install --no-install-recommends -y python3-setuptools python3-dev python3-pip ruby

# Packages for esesc
RUN apt-get install --no-install-recommends -y libboost-dev cmake flex bison libpixman-1-dev libbz2-dev
RUN apt-get install --no-install-recommends -y libsdl2-dev python2.7 libncurses5-dev libncursesw5-dev

# Packages for lgraph
RUN ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN echo "America/Los_Angeles" > /etc/timezone
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
RUN mkdir -p /root/bazel
WORKDIR /root/bazel
#ENV PATH=$PATH:/usr/local/bin
RUN apt-get install --no-install-recommends -y wget unzip
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.17.2/bazel-0.17.2-installer-linux-x86_64.sh \
  && chmod 755 bazel*.sh \
  && ./bazel*.sh
RUN rm -rf /root/bazel

# prebuild lgraph to have a nice bazel cache for speed
#RUN mkdir -p /root/tmp/
#WORKDIR /root/tmp/
#RUN git clone https://github.com/masc-ucsc/lgraph.git
##WORKDIR /root/tmp/lgraph
#RUN bazel build //... \
# && bazel build -c dbg //...

# Packages for debugging when the image fails
#RUN apt-get install --no-install-recommends -y vim gdb

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup to save some space
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

