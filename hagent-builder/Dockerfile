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
      make \
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

# install bazelisk (symlinked to bazel for compatibility)
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
      -o /usr/local/bin/bazel && \
    chmod 755 /usr/local/bin/bazel

# chisel
RUN apt-get install -y openjdk-17-jre

COPY install-slang.sh /tmp/install-slang.sh
RUN bash /tmp/install-slang.sh

# UV used by hagent (yosys uses it too)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY install-yosys.sh /tmp/install-yosys.sh
RUN bash /tmp/install-yosys.sh

COPY install-openroad.sh /tmp/install-openroad.sh
RUN bash /tmp/install-openroad.sh

COPY install-verilator.sh /tmp/install-verilator.sh
RUN bash /tmp/install-verilator.sh

RUN apt-get install -y iverilog


# Some cleanup for space
RUN rm -rf /var/lib/apt/lists/*

# copy entrypoint and make executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

# default working directory
RUN mkdir -p /code/rtl /code/verif /code/docs /app /code/mcp-servers /code/workspace /code/hagent

# Create mountpoints in workspace
RUN mkdir -p /code/workspace/cache /code/workspace/build /code/workspace/repo /code/workspace/tech
