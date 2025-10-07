FROM mascucsc/hagent-builder:2025.10

# Install the packages that SoomRV requires but hagent-builder base image does not have.
RUN apt-get update && apt-get install -y \
    device-tree-compiler \
    autoconf automake autotools-dev python3 python3-pip python3-tomli \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex \
    texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
    ninja-build git cmake libglib2.0-dev libslirp-dev \
    libfl2 libfl-dev libexpat1-dev pkg-config python3-colorama wget ccache \
    && rm -rf /var/lib/apt/lists/*

# Set the current working directory early to clone SoomRV and build its required toolchains.
WORKDIR /code/workspace/

# Unlike CVA6/XiangShan/... we use the latest from the repo all the time
RUN git clone https://github.com/mathis-s/SoomRV.git repo

# Copy hagent configuration
COPY hagent.yaml repo

ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH

RUN git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git && \
    cd riscv-gnu-toolchain && \
    git checkout 2024.10.28 && \
    git submodule init && \
    rm -rf qemu && \
    git submodule update --recursive && \
    ./configure --prefix=/opt/riscv --with-arch=rv32imac_zba_zbb --with-abi=ilp32 && \
    make -j $(nproc) && \
    make install && \
    cd .. && rm -r riscv-gnu-toolchain

RUN cd /opt && \
    git clone https://github.com/mathis-s/riscv-isa-sim-SoomRV.git riscv-isa-sim && \
    cd riscv-isa-sim &&\
    git checkout 994579ca5898dc7438beb3f47143c1ecb6be1a21 && \
    rm -rf .git && \
    ./configure CFLAGS="-Os -g0" CXXFLAGS="-Os -g0" --with-boost=no --with-boost-asio=no --with-boost-regex=no && \
    make -j $(nproc)

RUN cd /opt && \
    git clone --recursive https://github.com/riscv-software-src/riscv-tests.git && \
    cd riscv-tests && \
    git checkout 51de00886cd28a3cf9b85ee306fb2b5ee5ab550e && \
    rm -rf .git && \
    ./configure --with-xlen=32 --prefix=/opt/riscv/ && \
    make isa

RUN riscv32-unknown-elf-gcc --version && verilator --version

COPY hagent.yaml /code/workspace/repo/

COPY fix-verilator-5.040.patch /code/workspace/repo

WORKDIR /code/workspace/repo

RUN patch -p1 < fix-verilator-5.040.patch

RUN git config --global --add safe.directory '*' && \
    rm -rf riscv-isa-sim && \
    mv /opt/riscv-isa-sim . && \
    mkdir logs

# Set up HAgent and SoomRV build environment
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build
