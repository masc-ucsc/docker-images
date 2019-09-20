FROM archlinux/base

RUN pacman -Suy --noconfirm

# Packages for most tools
RUN pacman -S --noconfirm bazel git clang llvm ruby python linux-tools gcc

# Base devel
RUN pacman -Sy --noconfirm --needed base-devel

# Packages for Yosys
RUN pacman -S --noconfirm tcl tk

# Packages for ESESC
RUN pacman -S --noconfirm boost cmake pixman python2

# Packages for Debuggin/develop
RUN pacman -S --noconfirm gdb vim

# Packages for Pyrope
#RUN pacman -S --noconfirm yarn nodejs

# Packages for lgraph
#RUN pacman -S --noconfirm rapidjson cryptominisat5

# Yosys
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
#RUN git clone https://github.com/rafaeltp/yosys.git
WORKDIR /root/yosys
RUN make config-clang \
 && make -j$(nproc) \
 && make install
RUN rm -rf /root/yosys

# Latest lcov version to work with gcc (arch linux latest version does not have it)
WORKDIR /root
RUN git clone https://github.com/linux-test-project/lcov.git
WORKDIR /root/lcov
RUN make install
RUN rm -rf /root/lcov

RUN pacman -S --noconfirm wget perl-json
WORKDIR /root
RUN wget https://cpan.metacpan.org/authors/id/N/NW/NWCLARK/PerlIO-gzip-0.20.tar.gz
RUN tar xzvf PerlIO*tar.gz
WORKDIR /root/PerlIO-gzip-0.20
RUN perl Makefile.PL \
 && make \
 && make install
RUN rm -rf /root/PerlIO*

# prebuild lgraph to have a nice bazel cache for speed
#RUN mkdir -p /root/tmp/
#WORKDIR /root/tmp/
#RUN git clone https://github.com/masc-ucsc/lgraph.git
#WORKDIR /root/tmp/lgraph
#RUN bazel build //... \
# && bazel build -c dbg //...

# Packages for debugging when the image fails
#RUN pacman -S --noconfirm vim gdb

# Packages for lcov (coveralls)
RUN gem install coveralls-lcov --no-user-install
WORKDIR /root
#RUN echo "export PATH=$PATH" > /etc/environment

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup space to save some space
RUN rm -f /var/cache/pacman/pkg/*
RUN rm -f /var/lib/pacman/sync/*
RUN rm -f /etc/pacman.d/mirrorlist.pacnew

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/bin/bash"]

