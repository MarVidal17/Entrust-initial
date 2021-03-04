# Task 1

To compile go:
```
go build server.go 
```

To build docker image:
```
docker build -t initialserver . 
```

To run docker image:
```
docker run --publish 8080:8080 initialserver:latest
```

Check it is running:
```
$ curl localhost:8080
Hi, I'm Blue
```