FROM golang:1.15.6 as build

COPY . .

RUN go build -o /out/server .

FROM alpine as deploy

COPY --from=build /out/server /

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2

CMD ["/server"]

EXPOSE 8080