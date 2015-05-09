# Devenv

This project contains all the files and scripts I use when creating a dev env.
This project does not care much about how large the container ends up being.
It just cares about that it's download and start working.
So expect a big download if you do decide to use this.

## What's inside?

* simple init executable that can be used as PID 1 in a docker container  
* Golang devenv, a go environment set up with some tools like gb, dlv to work on go code
  * generic image (godev)
  * personalized environment with my vim setup (mygodev)
* packer to build vagrant boxes with an arch linux install
* Vagrant to set up an arch base image with docker

## Running

To run

```bash
docker run -dit \
  --name godev  \
  -u `id -u`:`id -g` \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DOCKER_HOST=unix:///var/run/docker.sock \
  -v $GOPATH/src:/home/ivan/go/src \
  -v $HOME/.ssh:/home/ivan/.ssh \
  -v $SSH_AUTH_SOCK:/var/run/ssh-auth.sock \
  -e SSH_AUTH_SOCK=/var/run/ssh-auth.sock \
  casualjim/mygodev
```

To use:

```bash
docker exec -it godev zsh
```



