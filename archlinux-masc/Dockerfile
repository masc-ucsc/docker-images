FROM archlinux/base

RUN pacman -Suy --noconfirm

# Packages for most tools
RUN pacman -S base-devel bazel git gcc clang llvm --noconfirm

# Packages for ESESC
RUN pacman -S boost cmake flex bison pixman --noconfirm

# Packages for Pyrope
RUN pacman -S yarn nodejs --noconfirm

# Packages for lgraph
RUN pacman -S tcl mercurial --noconfirm

# Cleanup space
RUN rm -f /var/cache/pacman/pkg/*
RUN rm -f /var/lib/pacman/sync/*
RUN rm -f /etc/pacman.d/mirrorlist.pacnew

CMD ["/bin/bash"]

