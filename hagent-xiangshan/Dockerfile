FROM mascucsc/hagent-builder:2025.12

ENV NOOP_HOME=/code/workspace/repo
ENV NEMU_HOME=/code/workspace/NEMU

RUN curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/0.13.0-M0/mill -o /usr/local/bin/mill && \
    chmod 755 /usr/local/bin/mill

WORKDIR /code/workspace

#RUN git clone --recursive https://github.com/OpenXiangShan/XiangShan.git repo
RUN git clone --filter=blob:none --no-checkout https://github.com/OpenXiangShan/XiangShan.git repo && \
  cd repo && \
  BRANCH="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's|^origin/||')" && \
  BRANCH="${BRANCH:-$(git remote show origin | sed -n 's/.*HEAD branch: //p')}" && \
  git checkout "$(git rev-list -n 1 --before="2025-08-16" "$BRANCH")" && \
  git submodule update --init --recursive --jobs 8

#RUN git clone --recursive https://github.com/OpenXiangShan/NEMU.git
RUN git clone --filter=blob:none --no-checkout https://github.com/OpenXiangShan/NEMU.git && \
  cd NEMU && \
  BRANCH="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's|^origin/||')" && \
  BRANCH="${BRANCH:-$(git remote show origin | sed -n 's/.*HEAD branch: //p')}" && \
  git checkout "$(git rev-list -n 1 --before="2025-08-16" "$BRANCH")" && \
  git submodule update --init --recursive --jobs 8

# Copy patch file and hagent.yaml
COPY xiangshan.patch /code/workspace/repo/
COPY hagent.yaml /code/workspace/repo/

WORKDIR /code/workspace/repo

# Apply the patch
RUN patch -p1 < xiangshan.patch

ENV PATH="/usr/local/bin:${PATH}"
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

# Run the updated make commands
RUN make BUILD_DIR=/code/workspace/build/build_opt CONFIG=MinimalConfig EMU_THREADS=2 EMU_TRACE=1 emu
RUN make BUILD_DIR=/code/workspace/build/build_dbg DEBUG_VERILOG=1 CONFIG=MinimalConfig EMU_THREADS=2 sim-verilog
