FROM base/devel

RUN pacman -Suy --noconfirm

# Packages for most tools
RUN pacman -S --noconfirm bazel git clang llvm ruby python linux-tools

# Packages for Yosys
RUN pacman -S --noconfirm tcl tk

# Packages for ESESC
RUN pacman -S --noconfirm boost cmake pixman python2

# Packages for Pyrope
#RUN pacman -S --noconfirm yarn nodejs

# Packages for lgraph
#RUN pacman -S --noconfirm rapidjson cryptominisat5

# Yosys
WORKDIR /root
#RUN git clone https://github.com/YosysHQ/yosys.git
RUN git clone https://github.com/rafaeltp/yosys.git
WORKDIR /root/yosys
RUN make config-clang \
 && make -j$(nproc) \
 && make install
RUN rm -rf /root/yosys

# prebuild lgraph to have a nice bazel cache for speed
#RUN mkdir -p /root/tmp/
#WORKDIR /root/tmp/
#RUN git clone https://github.com/masc-ucsc/lgraph.git
#WORKDIR /root/tmp/lgraph
#RUN bazel build //... \
# && bazel build -c dbg //...

# Packages for debugging when the image fails
RUN pacman -S --noconfirm vim gdb

# Packages for lcov (coveralls)
RUN gem install coveralls-lcov --no-user-install --no-rdoc --no-ri
WORKDIR /root
# Latest lcov as previous has problems with gcc 8.x
RUN git clone https://github.com/linux-test-project/lcov.git
WORKDIR /root/lcov
RUN make -j2 install
RUN rm -rf /root/lcov
#RUN echo "export PATH=$PATH" > /etc/environment

# Leave this as the default directory (just clean)
WORKDIR /root/

# Cleanup space to save some space
RUN rm -f /var/cache/pacman/pkg/*
RUN rm -f /var/lib/pacman/sync/*
RUN rm -f /etc/pacman.d/mirrorlist.pacnew

CMD ["/bin/bash"]

