FROM mascucsc/hagent-builder:2025.12

# Switch to user early
#USER user
WORKDIR /code/workspace

RUN curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup -y --apps sbt

ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}"
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

# Unlike CVA6/XiangShan/... we use the latest from the repo all the time
RUN git clone https://github.com/masc-ucsc/simplechisel.git /code/workspace/repo

WORKDIR /code/workspace/repo
RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt compile

RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain gcd.GCD"

RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUNoDebug"
RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUDebug"

RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedNoDebug"
RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedDebug"

RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedDualIssueNoDebug"
RUN export PATH="/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedDualIssueDebug"

RUN --mount=type=bind,from=tech,target=/code/workspace/tech \
    --mount=type=bind,from=hagent,target=/code/hagent \
  cd /code/workspace/build && \
  /code/hagent/scripts/synth.py --top PipelinedCPU --netlist build_pipelined_d/netlist.v -F build_pipelined_d/filelist.f
