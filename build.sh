#!/bin/bash

TAG_DATE=${TAG_DATE:-$(date +'%Y.%m')}

docker build -f archlinux-masc/Dockerfile -t archlinux-masc:${TAG_DATE} ./archlinux-masc


