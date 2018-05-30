#BROKEN! Just starting to setup
#Try centos:6 to see if we can get it working. Otherwise, 7
FROM centos:7

RUN yum -y update && yum clean all
RUN yum -y install epel-release
RUN yum groupinstall -y 'Development Tools'

# Packages for most tools
RUN yum install -y clang clang-devel llvm-devel cmake3 cmake python-testtools python-pip wget python3-devel
RUN yum install -y python3-devel python3-pip

