#BROKEN! Just starting to setup
#Try centos:6 to see if we can get it working. Otherwise, 7
FROM centos:7

#In case that we need private key to setup something (not public repos)
#ARG SSH_PRIVATE_KEY
#RUN mkdir /root/.ssh/
#RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
# [...]
#RUN rm /root/.ssh/id_rsa

RUN yum -y update && yum clean all
RUN yum -y install epel-release
RUN yum groupinstall -y 'Development Tools'

# Packages for most tools
RUN yum install -y clang clang-devel llvm-devel cmake3 cmake python-testtools python-pip wget python3-devel
RUN yum install -y python3-devel python3-pip wget

# bazel
WORKDIR /etc/yu.repos.d
RUN wget https://copr.fedorainfracloud.org/coprs/vbatts/bazel/repo/epel-7/vbatts-bazel-epel-7.repo
RUN yum install -y bazel

# cryptominisat needed by lgraph
#WORKDIR /root
#RUN git clone https://github.com/msoos/cryptominisat.git
#WORKDIR /root/cryptominisat
#RUN git submodule update --init
#WORKDIR /root/cryptominisat/build
#RUN cmake .. \
 #&& make -j2 \
 #&& make install \
 #&& ldconfig

# Yosys
WORKDIR /root
RUN git clone https://github.com/YosysHQ/yosys.git
WORKDIR yosys
RUN make config-gcc \
 && make -j$(nproc) \
 && make install

