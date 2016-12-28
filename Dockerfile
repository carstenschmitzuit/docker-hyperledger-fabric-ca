# Dockerfile for Hyperledger fabric cop image.
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric-cop
# More usage infomation, please see https://github.com/hyperledger/fabric-cop.

FROM golang:1.7
MAINTAINER Baohua Yang

ENV COP_DEBUG false
ENV COP $GOPATH/src/github.com/hyperledger/fabric-cop
# Then we can run `cop` cmd directly
ENV PATH=$COP/bin:$PATH

EXPOSE 8888

RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && mkdir -p /var/hyperledger/fabric/.cop

RUN go get github.com/go-sql-driver/mysql \
    && go get github.com/lib/pq

# clone and build cop
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric-cop \
    && cd fabric-cop \
    && mkdir -p bin && cd cli && go build -o ../bin/cop

WORKDIR $GOPATH/src/github.com/hyperledger/fabric-cop

# cop server start -ca $CA_CERTIFICATE -ca-key $CA_KEY_CERTIFICATE -config $COP_CONFIG -address "0.0.0.0"
CMD ["cop", "server", "start", "-ca", "./testdata/ec.pem", "-ca-key", "./testdata/ec-key.pem", "-config", "./testdata/cop.json", "-address", "0.0.0.0"]
