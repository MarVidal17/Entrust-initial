FROM alpine

COPY server /

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2

CMD ["/server"]

EXPOSE 8080