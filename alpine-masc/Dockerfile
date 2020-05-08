FROM alpine:edge

RUN apk update

# Packages for most tools
RUN apk add --no-cache clang g++ git make bash binutils-gold ruby
# python3-dev python3 ruby

# Packages for iassert
RUN apk add --no-cache libexecinfo-dev

# Packages for ESESC
RUN apk add --no-cache boost-dev cmake flex-dev bison pixman-dev

# Packages for Pyrope
#RUN apk add --no-cache yarn nodejs nodejs-npm

# Packages for lgraph
#RUN apk add --no-cache rapidjson-dev

# cryptominisat needed by lgraph
#WORKDIR /root
#RUN git clone https://github.com/msoos/cryptominisat.git
#WORKDIR /root/cryptominisat
#RUN git submodule update --init
#WORKDIR /root/cryptominisat/build
#RUN cmake -DNOZLIB=ON -DUSE_GAUSS=ON -DONLY_SIMPLE=ON -DENABLE_PYTHON_INTERFACE=OFF -DSTATICCOMPILE=on .. \
 #&& make -j2 libcryptominisat5 \
 #&& cp -a cmsat5-src/cryptominisat5 /usr/local/include \
 #&& cp -a lib/lib*.a /usr/local/lib

# Yosys
RUN apk add --no-cache gawk tcl-dev readline-dev libffi-dev
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
#RUN git clone https://github.com/rafaeltp/yosys.git
WORKDIR /root/yosys
#RUN git checkout a36d1701dd99736b82f64ed870e7464f2deae220 \
RUN make config-gcc \
 && make -j$(nproc) \
 && make install
RUN rm -rf /root/yosys

#bazel
#ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ADD https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
    /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub
ADD https://github.com/davido/bazel-alpine-package/releases/download/0.26.1/bazel-0.26.1-r0.apk \
    /tmp/bazel-0.26.1-r0.apk
RUN apk add /tmp/bazel-0.26.1-r0.apk
RUN rm -f /tmp/bazel*apk
# Perl is needed for bazel test //...
RUN apk add perl
#RUN mkdir -p /root/bazel
#WORKDIR /root/bazel
#RUN apk add /tmp/bazel-0.15.2-r0.apk
#ENV PATH=$PATH:/usr/local/bin
#RUN apk --no-cache add ca-certificates wget openjdk8 binutils-gold perl \
# && wget -q -O /etc/apk/keys/david@ostrovsky.org-5a0369d6.rsa.pub https://raw.githubusercontent.com/davido/bazel-alpine-package/master/david@ostrovsky.org-5a0369d6.rsa.pub \
# && wget -q https://github.com/davido/bazel-alpine-package/releases/download/0.13.0/bazel-0.13.0-r0.apk \
# && apk add bazel-0.13.0-r0.apk

# No prebuild in alpine to keep it small
#RUN mkdir -p /root/tmp/
#WORKDIR /root/tmp/
#RUN git clone https://github.com/masc-ucsc/lgraph.git
#WORKDIR /root/tmp/lgraph
#RUN bazel build //... \
 #&& bazel build -c dbg //...


# Packages for debugging when the image fails
RUN apk add gdb vim # muls-dbg


# Leave this as the default directory (just clean)
WORKDIR /root/

# Gosu alternative for user in system
RUN apk add sudo
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

RUN git clone https://github.com/ncopa/su-exec.git \
 && make -C su-exec \
 && cp su-exec/su-exec /usr/local/bin/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]

