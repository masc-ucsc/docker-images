FROM mascucsc/hagent-builder:2025.08

# Switch to user early
USER user
WORKDIR /code/workspace

RUN curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup -y --apps sbt

RUN git clone https://github.com/masc-ucsc/simplechisel.git repo

WORKDIR /code/workspace/repo
ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}" && sbt compile

RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}" && sbt "runMain gcd.GCD"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUNoDebug"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUDebug"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:${HOME}/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedDualIssueDebug"

