#!/bin/bash

TAG_DATE=${TAG_DATE:-$(date +'%Y.%m')}

docker login

docker tag  mascucsc/archlinux-masc:${TAG_DATE} mascucsc/archlinux-masc:latest
#docker push mascucsc/archlinux-masc:${TAG_DATE}
docker push mascucsc/archlinux-masc:latest
