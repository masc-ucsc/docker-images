FROM archlinux:latest

# 1) Remove deprecated [community] repo to avoid 404s on sync
RUN sed -i '/^\[community\]/,/^$/d' /etc/pacman.conf

# 2) Initialize pacman keyring and update the system
# This sequence ensures proper key initialization and trust
RUN pacman-key --init \
 && pacman-key --populate archlinux \
 && pacman -Sy --noconfirm archlinux-keyring \
 && pacman -Su --noconfirm

# 3) Clear cache and force refresh the package databases
RUN rm -rf /var/cache/pacman/pkg/* \
 && pacman -Syy

# 4) Install all required packages in one shot; --needed skips already-installed
# Note: python2 has been removed from Arch repos, linux-tools is a group
RUN pacman -S --noconfirm --needed \
      git clang llvm ruby python gcc \
      base-devel tcl tk boost cmake pixman \
      gdb vim wget perl-json \
      perf \
 && pacman -Scc --noconfirm    # clean package cache

# 5) Build & install Yosys, then clean up sources
WORKDIR /root
RUN git clone --depth=1 --recursive https://github.com/YosysHQ/yosys.git \
 && cd yosys \
 && make config-clang \
 && make -j"$(nproc)" install \
 && cd /root \
 && rm -rf yosys

# 6) install bazelisk (symlinked to bazel for compatibility)
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
      -o /usr/local/bin/bazel && \
    chmod 755 /usr/local/bin/bazel

# 7) Smoke-test critical binaries (assert tools are on PATH)
RUN for bin in bazel git clang ruby python gdb vim; do \
      command -v "$bin" >/dev/null || { echo "[ERROR] $bin missing"; exit 1; }; \
    done

# 8) Build and install su-exec for dropping privileges
RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec && \
    make -C /tmp/su-exec && \
    cp /tmp/su-exec/su-exec /usr/local/bin/ && \
    rm -rf /tmp/su-exec

# 9) Setup entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /root
CMD ["/usr/local/bin/entrypoint.sh"]
