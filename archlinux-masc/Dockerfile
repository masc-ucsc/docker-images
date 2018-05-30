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

# Cleanup space
RUN rm -f /var/cache/pacman/pkg/*
RUN rm -f /var/lib/pacman/sync/*
RUN rm -f /etc/pacman.d/mirrorlist.pacnew

CMD ["/bin/bash"]

