# docker-images

 Dockerfile to test software packages from MASC group

 This includes ESESC, lgraph, and Pyrope

 To run in interactive mode:

```
    # Launch docker with your home directory as write through (carefull, not virtual, but your real data)
    # -rm SYS_ADMIN allows to run perf stat inside docker
    docker run --rm --cap-add SYS_ADMIN -it -e LOCAL_USER_ID=$(id -u $USER) -v $HOME:/home/user mascucsc/archlinux-masc

    # Once inside docker image. Create local "user" at /home/user with your userid
    /usr/local/bin/entrypoint.sh
```

If you need to run gdb on the docker, you will also need to use the following flags:

```
    docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined
```

To lunch a bazelcache (caches for a week, and clears old data)

```
    docker run --name bazelcache -d -p 8082:80 mascucsc/bazelcache-masc:latest
```

An alternative (better?) to bazelcache is to use https://github.com/buildbarn/bb-storage

If the container crashed before, you may need to run docker rm xxxxxxxx before starting new one

