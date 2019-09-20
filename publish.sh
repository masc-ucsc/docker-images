#!/bin/bash

TAG_DATE=${TAG_DATE:-$(date +'%Y.%m')}

docker login

docker tag  mascucsc/archlinux-masc:${TAG_DATE} mascucsc/archlinux-masc:latest
docker push mascucsc/archlinux-masc:latest

#docker tag  mascucsc/ubuntu-masc:${TAG_DATE} mascucsc/ubuntu-masc:latest
#docker push mascucsc/ubuntu-masc:latest

#docker tag  mascucsc/alpine-masc:${TAG_DATE} mascucsc/alpine-masc:latest
#docker push mascucsc/alpine-masc:latest

#docker tag  mascucsc/bazelcache-masc:${TAG_DATE} mascucsc/bazelcache-masc:latest
#docker push mascucsc/bazelcache-masc:latest
