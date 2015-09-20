# Golang Devenv

This project contains the necessary files for creating a reproducible devenv for go.  
This support cross-compiling for mac, windows and linux through the use of the [gonative](https://github.com/inconshreveable/gonative) tool.

It uses vim as editor and zsh as shell.

For programming languages it contains:

It includes vim, zsh, python, node, ruby and go.

It's meant to run as a daemon container in which you exec to your shell. The daemon process is a simple init executable that reaps processes and allows for configuring services to run at startup. To add services to run at startup add an /etc/rc.local shell script.

You can of course just run the container with a shell as command but it has some issues wrt to zombie processes.

```
GOROOT=/usr/local/go
GOPATH=/usr/local/share/go
```
