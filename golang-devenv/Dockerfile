FROM debian:jessie
MAINTAINER Ivan Porto Carrero

ENV DEBIAN_FRONTEND noninteractive
ENV GOLANG_VERSION 1.4.2

ADD https://s3.amazonaws.com/casualjim.shared/gonative /tmp/gonative
ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /usr/bin/docker
ADD https://raw.githubusercontent.com/docker-library/golang/master/1.4/go-wrapper /usr/bin/go-wrapper

ADD simpleinit /usr/bin/
ADD setup.sh /tmp/
RUN /tmp/setup.sh && apt-get clean -q && rm -rf  /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV GOPATH /usr/local/go
ENV GOROOT /usr/src/go
ENV PATH /usr/local/go/bin:/usr/src/go/bin:$PATH

CMD ["/usr/bin/simpleinit"]
