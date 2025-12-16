FROM mascucsc/hagent-builder:2025.12

#USER user
WORKDIR /code/workspace

# Set environment variable for CVA6 RTL path
ENV CVA6_HOME=/code/workspace/repo
ENV DUT_ROOT=/code/workspace/repo

# Clone only CVA6 with submodules at a specific date (2025-08-16)
RUN git clone --filter=blob:none --no-checkout https://github.com/openhwgroup/cva6.git repo && \
  cd repo && \
  BRANCH=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's|^origin/||') && \
  BRANCH=${BRANCH:-$(git remote show origin | sed -n 's/.*HEAD branch: //p')} && \
  git checkout "$(git rev-list -n 1 --before=2025-08-16 "$BRANCH")" && \
  git submodule update --init --recursive --jobs 8

# Copy patch file and hagent.yaml (paths are relative to build context root)
# You are running: docker build -f docker-images/hagent-cva6/Dockerfile .
COPY cva6.patch /code/workspace/repo/
COPY hagent.yaml /code/workspace/repo/

WORKDIR /code/workspace/repo

# Apply the patch
RUN patch -p1 < cva6.patch

# This is the default config for CVA6, not set to allow many
RUN touch /code/workspace/repo/core/include/_config_pkg.sv

ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

ENV HPDCACHE_DIR=/code/workspace/repo/core/cache_subsystem/hpdcache
ENV CVA6_REPO_DIR=/code/workspace/repo
