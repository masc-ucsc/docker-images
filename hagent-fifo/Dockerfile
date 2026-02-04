FROM mascucsc/hagent-builder:2026.02

# Standard layout inside the container
ENV HAGENT_WORKSPACE=/code/workspace
ENV HAGENT_DIR=/code/hagent
ENV HAGENT_PRIVATE_DIR=/code/hagent-private

WORKDIR ${HAGENT_WORKSPACE}

# Copy your FIFO repo into the workspace as "repo"
# (Fall2025/fifo must exist in your build context)
COPY fifo ${HAGENT_WORKSPACE}/repo

# Set HAgent env vars used by cli_formal
ENV HAGENT_REPO_DIR=${HAGENT_WORKSPACE}/repo
ENV HAGENT_BUILD_DIR=${HAGENT_WORKSPACE}/build
ENV SLANG_BIN=/usr/local/bin/slang

# (Optional) copy FIFO-specific hagent.yaml into the repo
# If you don't have one yet, you can comment this out.
COPY hagent.yaml ${HAGENT_REPO_DIR}/hagent.yaml

# NOTE: we do NOT run cli_formal or uv at build time to avoid "uv: command not found"
# We’ll run cli_formal manually inside the container.
