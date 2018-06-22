FROM archlinux/base

RUN pacman -Suy --noconfirm

# Packages for most tools
RUN pacman -S --noconfirm base-devel bazel git gcc clang llvm ruby

# Packages for ESESC
RUN pacman -S --noconfirm boost cmake flex bison pixman

# Packages for Pyrope
RUN pacman -S --noconfirm yarn nodejs

# Packages for lgraph
RUN pacman -S --noconfirm tcl tk rapidjson mercurial python-pip cryptominisat5
RUN pip3 install ptpython

# Yosys
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
WORKDIR /root/yosys
RUN make config-clang \
 && make -j2 \
 && make install

# prebuild lgraph to have a nice bazel cache for speed
RUN mkdir -p /root/tmp/
WORKDIR /root/tmp/
RUN git clone https://github.com/masc-ucsc/lgraph.git
WORKDIR /root/tmp/lgraph
RUN bazel build //... \
 && bazel build -c dbg //...

# Packages for debugging when the image fails
RUN pacman -S --noconfirm vim gdb

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup space to save some space
RUN rm -f /var/cache/pacman/pkg/*
RUN rm -f /var/lib/pacman/sync/*
RUN rm -f /etc/pacman.d/mirrorlist.pacnew

CMD ["/bin/bash"]

