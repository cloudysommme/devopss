FROM alpine:latest AS builder

RUN apk add --no-cache g++ make autoconf automake libtool

WORKDIR /build
RUN apk add --no-cache git && \
    git clone --branch branchHTTPservMutli https://github.com/cloudysommme/devopss.git .
RUN ls -la /build  && autoreconf -i && ./configure && make

FROM alpine:latest

RUN apk add --no-cache libstdc++ libc6-compat

WORKDIR /app
COPY --from=builder /build/myprogram .

ENTRYPOINT ["./myprogram", "server"]

