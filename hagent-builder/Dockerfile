FROM ubuntu:24.04

# avoid interactive prompts (e.g. tzdata)
ENV DEBIAN_FRONTEND=noninteractive

# use bash instead of dash for /bin/sh
SHELL ["/bin/bash", "-c"]
RUN ln -sf /bin/bash /bin/sh

# update, upgrade, install all required packages + tzdata, set timezone, clean up
RUN apt-get update && \
    apt-get upgrade --no-install-recommends -y && \
    apt-get install --no-install-recommends -y \
      tzdata \
      ca-certificates \
      build-essential \
      git \
      gcc \
      g++ \
      clang \
      cmake \
      vim \
      llvm \
      curl \
      gnupg \
      openssh-client \
      python3-dev \
      python3-markupsafe \
      python3-poetry \
      software-properties-common \
      ruby \
      tclcl-dev \
      gawk \
      libreadline-dev \
      tcl \
      tcl-dev \
      tk-dev \
      rapidjson-dev \
      libffi-dev \
      sudo \
      nodejs \
      npm \
      time \
      libboost-all-dev && \
    ln -snf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    echo "America/Los_Angeles" > /etc/timezone

# Packages needed for openroad
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.10 python3.10-venv python3.10-dev libqt5gui5t64 libqt5charts5 tcl-tclreadline

# install bazelisk (symlinked to bazel for compatibility)
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
      -o /usr/local/bin/bazel && \
    chmod 755 /usr/local/bin/bazel

# install Miniconda3
ENV CONDA_DIR=/usr/local/miniconda3
ENV PATH="$CONDA_DIR/bin:$PATH"

RUN curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
      -o /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p "$CONDA_DIR" && \
    rm /tmp/miniconda.sh

# ensure conda is on PATH for interactive shells
RUN echo 'export PATH='"$CONDA_DIR"'/bin:$PATH' > /etc/profile.d/conda.sh

# install OSS-CAD suite
# ENV OSS_CAD_DIR=/usr/local/oss-cad-suite
#
# RUN curl -L https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-06-30/oss-cad-suite-linux-x64-20250630.tgz \
#       -o /tmp/oss-cad-suite.tgz && \
#     mkdir -p "$OSS_CAD_DIR" && \
#     tar xzf /tmp/oss-cad-suite.tgz -C /usr/local && \
#     rm /tmp/oss-cad-suite.tgz && \
#     echo "source $OSS_CAD_DIR/environment" > /etc/profile.d/oss_cad.sh

# chisel
# RUN curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/0.13.0-M0/mill -o /usr/local/bin/mill && \
#     chmod 755 /usr/local/bin/mill
# RUN apt-get install -y g++-riscv64-linux-gnu openjdk-11-jre
RUN apt-get install -y openjdk-17-jre

RUN git clone https://github.com/MikePopoloski/slang.git /tmp/slang &&\
  cd /tmp/slang && \
  cmake -B build && \
  cmake --build build -j && \
  cd build && \
  make install && \
  rm -rf /tmp/slang

RUN apt-get install -y flex bison autoconf sqlite3 libsqlite3-dev libzstd-dev libreadline6-dev libsdl2-dev zlib1g-dev

RUN curl -L -o /tmp/yosys.tar.gz https://github.com/YosysHQ/yosys/releases/download/v0.57/yosys.tar.gz &&\
  mkdir /tmp/yosys && \
  cd /tmp/yosys && \
  tar xzf ../yosys.tar.gz && \
  make config-gcc && \
  make -j 16 && \
  make install && \
  rm -rf /tmp/yosys*

RUN git clone --recursive https://github.com/povik/yosys-slang /tmp/yosys-slang && \
  cd /tmp/yosys-slang/build && \
  cmake .. && \
  make -j 16 && \
  make install && \
  rm -rf /tmp/yosys-slang

RUN curl -L -o /tmp/openroad.deb https://github.com/Precision-Innovations/OpenROAD/releases/download/2024-12-14/openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb && \
  dpkg -i /tmp/openroad.deb && \
  rm -f /tmp/openroad.deb

# Verilog simulation common tools (icarus too?)
RUN apt-get install -y verilator iverilog

# Some cleanup for space
RUN rm -rf /var/lib/apt/lists/*

# copy entrypoint and make executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

# default working directory
RUN mkdir -p /code/rtl /code/verif /code/docs /app /code/mcp-servers /code/workspace /code/hagent

# Create mountpoints in workspace
RUN mkdir -p /code/workspace/cache /code/workspace/build /code/workspace/repo /code/workspace/tech

# TODO
#COPY slang-slicer /usr/local/bin/slice-slicer

# TODO
# Create MCP wrapper for hagent.yaml commands
#COPY mcp-hagent-wrapper/ /code/mcp-servers/hagent/
#COPY mcp-filesystem-server/ /code/mcp-servers/filesystem/

# Install MCP dependencies
#RUN cd /code/mcp-servers/hagent && npm install
#RUN cd /code/mcp-servers/filesystem && npm install

# Create default user with UID 9001 in Dockerfile
#
# RUN groupadd -g 9001 guser && \
#     useradd --create-home --shell /bin/bash --uid 9001 --gid guser user && \
#     echo "user:user" | chpasswd && \
#     echo "user ALL=(ALL) ALL" >> /etc/sudoers
#
# # set ownership in Dockerfile
# RUN chown -R user:guser /code /app
#
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
