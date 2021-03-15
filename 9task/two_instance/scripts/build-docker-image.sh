#!/bin/sh
printf '
FROM golang AS build

COPY ./app/server.go /app/server.go
WORKDIR /app

RUN go build -o server server.go

####################

FROm alpine AS server

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2
  
COPY --from=build /app/server /app/server

EXPOSE 80

CMD ["/app/server"]
' > ~/scripts/Dockerfile


docker build -t mybuild --target build -f scripts/Dockerfile .
docker build -t simple-go-server --target server -f scripts/Dockerfile .

docker run -p 80:80 -d simple-go-server