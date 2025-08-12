FROM mascucsc/hagent-builder:2025.08

USER user
WORKDIR /code/workspace

# Set environment variable for CVA6 RTL path
ENV CVA6_HOME=/code/workspace/repo
ENV DUT_ROOT=/code/workspace/repo

# Clone only CVA6 with submodules
RUN git clone --recursive https://github.com/openhwgroup/cva6.git repo
COPY hagent.yaml /code/workspace/repo/

WORKDIR /code/workspace/repo
RUN mkdir /code/workspace/build

ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

ENV HPDCACHE_DIR=/code/workspace/repo/core/cache_subsystem/hpdcache
ENV CVA6_REPO_DIR=/code/workspace/repo

