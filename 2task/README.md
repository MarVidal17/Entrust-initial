# Task 2

To build docker image:
```
docker build -t multistage . 
```

To run docker image:
```
docker run --publish 8080:8080 multistage:latest
```

Check it is running:
```
$ curl localhost:8080
Hi, I'm Blue
```