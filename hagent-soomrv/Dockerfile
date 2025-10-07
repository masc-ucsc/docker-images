FROM mascucsc/hagent-builder:2025.10

WORKDIR /code/workspace

# Set environment variables for SoomRV
ENV SOOMRV_HOME=/code/workspace/repo
ENV DUT_ROOT=/code/workspace/repo

# Install additional dependencies for SoomRV
RUN apt-get update && apt-get install -y \
    device-tree-compiler \
    autoconf automake autotools-dev python3 python3-pip python3-tomli \
    libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex \
    texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
    ninja-build git cmake libglib2.0-dev libslirp-dev \
    && rm -rf /var/lib/apt/lists/*

# Build RISC-V GNU Toolchain for 32-bit bare-metal (newlib only, skip qemu/glibc)
RUN git clone https://github.com/riscv-collab/riscv-gnu-toolchain /tmp/riscv-gnu-toolchain && \
    cd /tmp/riscv-gnu-toolchain && \
    git submodule update --init --recursive binutils gcc newlib && \
    ./configure --prefix=/opt/riscv --with-arch=rv32i --with-abi=ilp32 && \
    make -j$(nproc) && \
    rm -rf /tmp/riscv-gnu-toolchain

# Add RISC-V toolchain to PATH
ENV PATH="/opt/riscv/bin:$PATH"

# Clone SoomRV repository
RUN git clone --filter=blob:none --no-checkout https://github.com/mathis-s/SoomRV.git repo && \
  cd repo && \
  BRANCH="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's|^origin/||')" && \
  BRANCH="${BRANCH:-$(git remote show origin | sed -n 's/.*HEAD branch: //p')}" && \
  git checkout "$BRANCH" && \
  git submodule update --init --recursive --jobs 8

# Copy hagent configuration
COPY hagent.yaml /code/workspace/repo/

WORKDIR /code/workspace/repo

# Set up HAgent and SoomRV build environment
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build
ENV SOOMRV_ROOT=/code/workspace/repo
