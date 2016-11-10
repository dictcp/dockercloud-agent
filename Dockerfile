FROM golang:1.5.4

# Install FPM for packaging
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -qy ruby ruby-dev rpm socat nginx-extra netcat-openbsd vim curl && \
	gem install --no-rdoc --no-ri fpm --version 1.0.2

ENV GOPATH /go
WORKDIR /go/src/github.com/docker/dockercloud-agent
ADD . /go/src/github.com/docker/dockercloud-agent
RUN go get -d -v && go build -v
RUN ln -s /go/src/github.com/docker/dockercloud-agent/dockercloud-agent /usr/bin/dockercloud-agent
ADD run.sh /
ADD tls-proxy.sh /
ADD socat.sh /
ADD nginx.sh /

EXPOSE 2375
CMD ["/run.sh"]
