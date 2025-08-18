FROM mascucsc/hagent-builder:2025.08

ENV NOOP_HOME=/code/workspace/repo
ENV NEMU_HOME=/code/workspace/NEMU

USER user
WORKDIR /code/workspace

RUN git clone --recursive https://github.com/OpenXiangShan/XiangShan.git repo
RUN git clone --recursive https://github.com/OpenXiangShan/NEMU.git

# Copy patch file and hagent.yaml
COPY xiangshan.patch /code/workspace/repo/
COPY hagent.yaml /code/workspace/repo/

WORKDIR /code/workspace/repo

# Apply the patch
RUN patch -p1 < xiangshan.patch

ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${PATH}"
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

# Run the updated make commands
RUN make BUILD_DIR=/code/workspace/build/build_opt CONFIG=MinimalConfig EMU_THREADS=2 EMU_TRACE=1 emu
RUN make BUILD_DIR=/code/workspace/build/build_dbg DEBUG_VERILOG=1 CONFIG=MinimalConfig EMU_THREADS=2 sim-verilog
