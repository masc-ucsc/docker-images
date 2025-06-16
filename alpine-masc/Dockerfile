FROM alpine:3.20

# 1) Full upgrade + install all build/runtime deps in one go
RUN apk upgrade --available --no-cache \
 && apk add --no-cache \
      build-base        \
      gawk              \
      tcl-dev           \
      readline-dev      \
      libffi-dev        \
      flex-dev          \
      bison             \
      boost-dev         \
      cmake             \
      pixman-dev        \
      gdb               \
      vim               \
      bash              \
      git               \
      curl              \
      binutils-gold     \
      ruby              \
      unzip             \
      openjdk17         \
      libc6-compat      \
      sudo              \
      su-exec           \
 && rm -rf /var/cache/apk/*

# 2) Install Bazelisk as 'bazel'
RUN curl -Lo /usr/local/bin/bazelisk \
      https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
 && chmod +x /usr/local/bin/bazelisk \
 && ln -s /usr/local/bin/bazelisk /usr/local/bin/bazel

# 3) Clone, build & install Yosys (with submodules) then clean up
WORKDIR /root
RUN git clone --depth 1 --recursive https://github.com/YosysHQ/yosys.git \
 && cd yosys \
 && make config-gcc \
 && make -j"$(nproc)" install \
 && cd / \
 && rm -rf /root/yosys

# 4) Smoke-test that key tools are on PATH
RUN for tool in bazel yosys git ruby python3; do \
      command -v "$tool" >/dev/null \
        || { echo "[ERROR] $tool missing"; exit 1; }; \
    done

# 5) Entrypoint + default working dir
RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec && \
    make -C /tmp/su-exec && \
    cp /tmp/su-exec/su-exec /usr/local/bin/ && \
    rm -rf /tmp/su-exec

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
WORKDIR /root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]


