#!/bin/sh

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
