FROM mascucsc/hagent-builder:latest

ENV NOOP_HOME=/code/XiangShan
ENV NEMU_HOME=/code/NEMU

# Switch to user early
USER user
WORKDIR /code

RUN git clone --recursive https://github.com/OpenXiangShan/XiangShan.git
RUN git clone --recursive https://github.com/OpenXiangShan/NEMU.git

WORKDIR /code/XiangShan
ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${PATH}"
RUN make emu CONFIG=MinimalConfig EMU_THREADS=1 -j8
