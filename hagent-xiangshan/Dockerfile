FROM mascucsc/hagent-builder:latest

ENV NOOP_HOME=/code/XiangShan
ENV NEMU_HOME=/code/NEMU

# Switch to user early
USER user
WORKDIR /code

RUN git clone --recursive https://github.com/OpenXiangShan/XiangShan.git
RUN git clone --recursive https://github.com/OpenXiangShan/NEMU.git

# Copy patch file and hagent.yaml
COPY xiangshan.patch /code/XiangShan/
COPY hagent.yaml /code/XiangShan/

WORKDIR /code/XiangShan

# Apply the patch
RUN patch -p1 < xiangshan.patch

WORKDIR /code/XiangShan
ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${PATH}"

# Run the updated make commands
RUN make CONFIG=MinimalConfig EMU_THREADS=2 EMU_TRACE=1 emu
RUN make DEBUG_VERILOG=1 CONFIG=MinimalConfig EMU_THREADS=2 sim-verilog
