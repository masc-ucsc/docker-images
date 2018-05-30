FROM ubuntu:rolling

RUN apt-get update

# Packages for most tools
RUN apt-get install --no-install-recommends -y ca-certificates build-essential git gcc g++ clang llvm curl gnupg

# Packages for esesc
RUN apt-get install --no-install-recommends -y libboost-dev cmake flex bison libpixman-1-dev libbz2-dev
RUN apt-get install --no-install-recommends -y libsdl2-dev python2.7 libncurses5-dev libncursesw5-dev

# Packages for Pyrope
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs npm yarn

# Packages for lgraph
RUN ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN echo "America/Los_Angeles" > /etc/timezone
RUN apt-get install --no-install-recommends -y tclcl-dev mercurial

# Python packages
RUN apt-get install --no-install-recommends -y python3-setuptools python3-dev python3-pip

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

