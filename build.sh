#!/bin/bash

TAG_DATE=${TAG_DATE:-$(date +'%Y.%m')}

# docker system prune
#
# --squash is an experimental flag
# To enable. Add a /etc/docker/daemon.json
# {
#    "experimental": true
# }
#

#docker build --squash -f archlinux-masc/Dockerfile -t mascucsc/archlinux-masc:${TAG_DATE} ./archlinux-masc | tee archlinux.log
#docker build -f archlinux-masc/Dockerfile -t mascucsc/archlinux-masc:${TAG_DATE} ./archlinux-masc | tee archlinux.log
#docker build -f kaliriscv-masc/Dockerfile -t mascucsc/kaliriscv-masc:${TAG_DATE} ./kaliriscv-masc | tee kaliriscv.log
#docker build -f alpine-masc/Dockerfile    -t mascucsc/alpine-masc:${TAG_DATE}    ./alpine-masc    | tee alpine.log
#docker build -f bazelcache-masc/Dockerfile    -t mascucsc/bazelcache-masc:${TAG_DATE}    ./bazelcache-masc    | tee bazelcache.log
docker build -f ubuntu-masc/Dockerfile    -t mascucsc/ubuntu-masc:${TAG_DATE}    ./ubuntu-masc    | tee ubuntu.log

#Run all the bazel setups
#docker ps -a
#docker commit b4f219f70323 mascucsc/archlinux-masc:2018.06

# list all the images
# docker images

# Stop and Remove all containers
#docker stop $(docker ps -aq)
#docker rm $(docker ps -aq)

# Remove all the images
#docker rmi -f $(docker images -aq)
