
# OPT1: Build directly at google
gcloud builds submit --timeout="2h" --tag gcr.io/masc-211823/archlinux-masc archlinux-masc
gcloud builds submit --timeout="2h" --tag gcr.io/masc-211823/alpine-masc alpine-masc

# OPT2: Publish local image at google
docker tag mascucsc/alpine-linux gcr.io/masc-211823/alpine-masc
docker push gcr.io/masc-211823/alpine-masc

# To test the google docker image. Get access permissions (once)
gcloud auth configure-docker

docker run gcr.io/masc-211823/archlinux-masc

# To list images at google
gcloud container images list

