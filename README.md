# docker-images

 Dockerfile to test software packages from MASC group

 This includes ESESC, livehd, and Pyrope

Remember, when running docker remove it (`docker run --rm`) on exit. Eg.: interactive bash

```
docker run -it  --rm DOCKER_IMAGE -c /bin/bash
```

 To run in interactive mode:

```
    # Launch docker with your home directory as write through (carefull, not virtual, but your real data)
    # -rm SYS_ADMIN allows to run perf stat inside docker
    docker run --rm --cap-add SYS_ADMIN -it -e LOCAL_USER_ID=$(id -u $USER) -v $HOME:/home/user mascucsc/archlinux-masc

    # Once inside docker image. Create local "user" at /home/user with your userid
    /usr/local/bin/entrypoint.sh
```

If you want to build riscv packages (like compiling spec), use this other
docker (it can also build livehd). Notice that kaliriscv is a docker to cross
compile riscv apps, not a riscv docker.

```
    docker run --rm --cap-add SYS_ADMIN -it -e LOCAL_USER_ID=$(id -u $USER) -v $HOME:/home/user mascucsc/kaliriscv-masc

    # Once inside docker image. Create local "user" at /home/user with your userid
    /usr/local/bin/entrypoint.sh

    # To compile SPEC2007
    # cd to spec20017
    # copy the riscv64 config
    cp /usr/local/src/riscv64.cfg config/
    ./install.sh
    source shrc

    # To build the intspeed benchmarks
    runcpu --config=riscv64 --action=build intspeed

    # This will compile (AND FAIL to run) xalancbmk (just copy the binary to your setup)
    runcpu --config=riscv64 --copies=1 --noreportable -iterations=1 623.xalancbmk
    mkdir bins
    cp benchspec/CPU/60*/exe/*.riscv64-64 bins/
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
```
    docker ps -a -q
```

