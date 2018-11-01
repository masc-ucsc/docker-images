# docker-images

 Dockerfile to test software packages from MASC group

 This includes ESESC, lgraph, and Pyrope

 To run in interactive mode:

```
 docker run -it -e LOCAL_USER_ID=$(id -u $USER) -v $HOME:${HOME} mascucsc/archlinux-masc
```

If you need to run gdb on the docker, you will also need to use the following flags:

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined
```
