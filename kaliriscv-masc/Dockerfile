FROM kalilinux/kali-linux-docker

# Basic packages to build stuff
RUN apt-get update && \
  apt-get install -y \
  g++ \
  gcc \
  git \
  make \
  cmake \
  flex \
  bison \
  m4 \
  vim \
  gdb

# RISCV tools
RUN apt-get install -y \
 linux-libc-dev-riscv64-cross libstdc++-9-pic-riscv64-cross libgomp1-riscv64-cross libgfortran-9-dev-riscv64-cross libgcc-9-dev-riscv64-cross gfortran-9-riscv64-linux-gnu g++-9-riscv64-linux-gnu gcc-riscv64-unknown-elf

# scripting
RUN apt-get install -y \
 ruby rake python2 python3 perl tk tcl

# Used by many software packages
RUN apt-get install -y \
 libboost-all-dev

#bazel
RUN mkdir -p /root/bazel
WORKDIR /root/bazel
#ENV PATH=$PATH:/usr/local/bin
RUN apt-get install --no-install-recommends -y wget unzip
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.28.1/bazel-0.28.1-installer-linux-x86_64.sh \
  && chmod 755 bazel*.sh \
  && ./bazel*.sh
RUN rm -rf /root/bazel

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup space to save some space
RUN rm -rf /var/lib/apt/lists/*

COPY riscv64.cfg /usr/local/src/riscv64.cfg
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]

