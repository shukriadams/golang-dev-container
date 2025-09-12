# build locally with : docker build .
FROM ubuntu:22.04

ENV GOPATH "/home/golangdev/go"
ENV PATH "$PATH:/usr/local/go/bin:$GOPATH/bin"

# must set user before installing go, else root owns all
USER golangdev

RUN apt-get update \
    && apt-get install -y curl git wget jq \
    && useradd -m golangdev \
    && su golangdev \
    # install go
    && wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz -O gol.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf gol.tar.gz \
    && rm gol.tar.gz \
    # configure go
    && echo "export GOPATH=/home/golangdev/go" >> ~/.bashrc \
    && echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin" >> ~/.bashrc \
    # install go dev extensions
    && go install github.com/go-delve/delve/cmd/dlv@v1.24.0 \
    && go install golang.org/x/tools/gopls@v0.19.1
