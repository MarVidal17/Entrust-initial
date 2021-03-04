FROM alpine

COPY server-blue /

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2

CMD ["/server-blue"]

EXPOSE 8080