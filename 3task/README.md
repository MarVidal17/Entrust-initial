# Task 3

## Option A

Docker file:
```docker
FROM golang:1.15.6 as build

COPY . .

RUN go build -o /out/server .

FROM alpine as deploy

COPY /container_folder /home
COPY --from=build /out/server /

RUN apk add --no-cache \
  ca-certificates \
  libc6-compat \
  libstdc++ \
  libltdl \
  iproute2

CMD ["/server"]

EXPOSE 8080
```

To build docker image:
```
docker build -t access_container . 
```

To run docker image:
```
docker run access_container:latest
```

Access to the container:
```
docker exec -it <conatiner_id> sh
```

Inside the shell:
```
/ # cd home/
/home # ls
Hello.txt
/home # exit
```

## Option B - Using volumes
Docker file:
```docker
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
```

To build docker image:
```
docker build -t access_container . 
```

To run docker image:
```
docker run --name container_vol -v /home/vidalm1/Desktop/initial/third_act/container_folder:/home --rm  access_container:latest 
```

Access to the container:
```
docker exec -it container_vol sh
```

Inside the shell:
```
/ # cd home/
/home # ls
Hello.txt
```
