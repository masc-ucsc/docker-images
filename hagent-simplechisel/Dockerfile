FROM mascucsc/hagent-builder:2025.09r

# Switch to user early
#USER user
WORKDIR /code/workspace

RUN curl -fL https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux.gz | gzip -d > cs && chmod +x cs && ./cs setup -y --apps sbt

# Unlike CVA6/XiangShan/... we use the latest from the repo all the time
RUN git clone https://github.com/masc-ucsc/simplechisel.git repo

ENV PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}"
ENV HAGENT_REPO_DIR=/code/workspace/repo
ENV HAGENT_BUILD_DIR=/code/workspace/build

WORKDIR /code/workspace/repo
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt compile

RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain gcd.GCD"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUNoDebug"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.SingleCycleCPUDebug"
RUN export PATH="${OSS_CAD_DIR}/bin/:/usr/local/bin:/root/.local/share/coursier/bin:${PATH}" && sbt "runMain dinocpu.pipelined.PipelinedDualIssueDebug"

