#!/bin/bash

TAG_DATE=${TAG_DATE:-$(date +'%Y.%m')}

docker build -f archlinux-masc/Dockerfile -t mascucsc/archlinux-masc:${TAG_DATE} ./archlinux-masc

