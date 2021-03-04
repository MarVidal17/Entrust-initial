FROM alpine

COPY server-green /

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2

CMD ["/server-green"]

EXPOSE 8080