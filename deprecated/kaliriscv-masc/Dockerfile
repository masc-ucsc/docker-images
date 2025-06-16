FROM kalilinux/kali-rolling

# Basic packages to build stuff
RUN apt update

RUN apt upgrade -y

RUN apt install -y g++ gcc git make cmake flex bison m4 vim gdb

# RISCV tools
RUN apt install -y \
 linux-libc-dev-riscv64-cross libstdc++-9-pic-riscv64-cross libgomp1-riscv64-cross libgfortran-9-dev-riscv64-cross libgcc-9-dev-riscv64-cross gfortran-9-riscv64-linux-gnu g++-9-riscv64-linux-gnu gcc-riscv64-unknown-elf g++-riscv64-linux-gnu

# scripting
RUN apt install -y \
 ruby rake python3 perl tk tcl

# Used by many software packages
RUN apt install -y \
 libboost-all-dev

#bazel
RUN mkdir -p /root/bazel
WORKDIR /root/bazel
RUN apt install -y wget unzip libzip-dev
#RUN wget https://github.com/bazelbuild/bazel/releases/download/0.28.1/bazel-0.28.1-installer-linux-x86_64.sh \
RUN wget https://github.com/bazelbuild/bazel/releases/download/2.0.0/bazel-2.0.0-installer-linux-x86_64.sh \
  && chmod 755 bazel*.sh \
  && ./bazel*.sh
RUN rm -rf /root/bazel

# Yosys
RUN apt install --no-install-recommends -y tcl-dev libreadline-dev libffi-dev
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
WORKDIR /root/yosys
RUN make config-gcc \
 && make -j$(nproc) \
 && make install
RUN rm -rf /root/yosys

# Typical packages to build buildroot and Linux
RUN apt install -y libncurses-dev bc rsync

# Use bash as default shell
RUN ln -sf /bin/bash /bin/sh

# Ariane and spike project
RUN apt install -y verilator device-tree-compiler
ENV RISCV /usr
WORKDIR /root/
RUN git clone https://github.com/riscv/riscv-isa-sim.git \
 && cd riscv-isa-sim \
 && mkdir build \
 && cd build \
 && ../configure \
 && make \
 && make install
RUN rm -rf /root/riscv-isa-sim

# Leave this as the default directory (just clean)
WORKDIR /root/

# Locale
#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL C

# Cleanup space to save some space
RUN rm -rf /var/lib/apt/lists/*

COPY riscv64.cfg /usr/local/src/riscv64.cfg
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]

