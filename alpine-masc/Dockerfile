FROM alpine:latest

RUN apk update

# Packages for most tools
RUN apk add --no-cache clang g++ git python3-dev python3 ruby make bash

# Packages for ESESC
RUN apk add --no-cache boost-dev cmake flex-dev bison pixman-dev

# Packages for Pyrope
RUN apk add --no-cache yarn nodejs nodejs-npm

# Packages for lgraph
RUN apk add --no-cache rapidjson-dev
RUN pip3 install ptpython

# cryptominisat needed by lgraph
WORKDIR /root
RUN git clone https://github.com/msoos/cryptominisat.git
WORKDIR /root/cryptominisat
RUN git submodule update --init
WORKDIR /root/cryptominisat/build
RUN cmake -DNOZLIB=ON -DUSE_GAUSS=ON -DONLY_SIMPLE=ON -DENABLE_PYTHON_INTERFACE=OFF -DSTATICCOMPILE=on .. \
 && make -j2 libcryptominisat5 \
 && cp -a cmsat5-src/cryptominisat5 /usr/local/include \
 && cp -a lib/lib*.a /usr/local/lib

# Yosys
RUN apk add --no-cache gawk tcl-dev readline-dev libffi-dev
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
WORKDIR /root/yosys
RUN make config-clang \
 && make -j2 \
 && make install

#bazel
RUN mkdir -p /root/bazel
WORKDIR /root/bazel
#ENV PATH=$PATH:/usr/local/bin
RUN apk --no-cache add ca-certificates wget openjdk8 binutils-gold perl \
 && wget -q -O /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
 && wget -q https://github.com/davido/bazel-alpine-package/releases/download/0.13.0/bazel-0.13.0-r0.apk \
 && apk add bazel-0.13.0-r0.apk
ENV JAVA_HOME=/usr/lib/jvm/default-jvm

# prebuild lgraph to have a nice bazel cache for speed
RUN mkdir -p /root/tmp/
WORKDIR /root/tmp/
RUN git clone https://github.com/masc-ucsc/lgraph.git
WORKDIR /root/tmp/lgraph
RUN bazel build //... \
 && bazel build -c dbg //...

# Packages for debugging when the image fails
RUN apk add gdb vim

# Leave this as the default directory (just clean)
WORKDIR /root/

CMD ["/bin/bash"]

