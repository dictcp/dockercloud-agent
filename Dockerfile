FROM golang:1.5.4

RUN sed -i 's/httpredir/deb/g' /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -qy nginx-full vim-tiny curl netcat-openbsd socat net-tools

ENV GOPATH /go
WORKDIR /go/src/github.com/docker/dockercloud-agent
ADD . /go/src/github.com/docker/dockercloud-agent
RUN go get -d -v && go build -v
RUN ln -s /go/src/github.com/docker/dockercloud-agent/dockercloud-agent /usr/bin/dockercloud-agent

ENV DOCKER_VERSION=1.11.2-cs5 NGROK_VERSION=1.7
ADD https://files.cloud.docker.com/packages/ngrok/ngrok-$NGROK_VERSION.tgz /tmp/
RUN mkdir -p /usr/lib/dockercloud/ && \
    tar zxf /tmp/ngrok-$NGROK_VERSION.tgz -C /usr/lib/dockercloud/ --strip-components 1
ADD run.sh /

ADD tls-proxy.sh /

EXPOSE 2375
ENTRYPOINT ["/run.sh"]
