# Task 4

## Task 4.1

To compile go (inside each folder):
```
go build server-blue.go 
go build server-green.go 
```

To build docker image (inside each folder):
```
docker build -t server-blue . 
docker build -t server-green . 
```
Load images:
```
kind --name myfirstcluster load docker-image server-green:latest
kind --name myfirstcluster load docker-image server-blue:latest
```

Run deployments and check status:
```
$ kubectl apply -f blue-deployment.yaml
deployment.apps/blue-deployment configured
$ kubectl apply -f green-deployment.yaml
deployment.apps/green-deployment configured
$ kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
blue-deployment    1/1     1            1           19m
green-deployment   1/1     1            1           19m
$ kubectl get pods       
NAME                                READY   STATUS    RESTARTS   AGE
blue-deployment-6b648ddcd-npvhj     1/1     Running   0          50s
green-deployment-6bb4f7c8c7-z5dtg   1/1     Running   0          31s
kubia                               1/1     Running   0          118m
```

Delete a pod and check it restores automatically:
```
$ kubectl get pods       
NAME                                READY   STATUS    RESTARTS   AGE
blue-deployment-6b648ddcd-npvhj     1/1     Running   0          50s
green-deployment-6bb4f7c8c7-z5dtg   1/1     Running   0          31s
kubia                               1/1     Running   0          118m
$ kubectl delete pods blue-deployment-6b648ddcd-npvhj
pod "blue-deployment-6b648ddcd-npvhj" deleted
$ kubectl get pods                                   
NAME                                READY   STATUS    RESTARTS   AGE
blue-deployment-6b648ddcd-gqzb4     1/1     Running   0          10s
green-deployment-6bb4f7c8c7-z5dtg   1/1     Running   0          5m3s
kubia                               1/1     Running   0          122m
```

### Get pods logs:
```
$ kubectl get pods                                                                
NAME                                READY   STATUS    RESTARTS   AGE
blue-deployment-6b648ddcd-fxq6z     1/1     Running   0          8s
green-deployment-6bb4f7c8c7-rq5w9   1/1     Running   0          21s
kubia                               1/1     Running   1          20h
$ kubectl logs blue-deployment-6b648ddcd-fxq6z
2021/03/03 10:09:27 Blue server working!
$ kubectl logs green-deployment-6bb4f7c8c7-rq5w9
2021/03/03 10:09:15 Green server working!
```

Request from one pod to the oder:
```
kubectl exec -it green-deployment-5d8486d64f-7stn8  -- sh
/ # apk add curl
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/community/x86_64/APKINDEX.tar.gz
(1/4) Installing brotli-libs (1.0.9-r3)
(2/4) Installing nghttp2-libs (1.42.0-r1)
(3/4) Installing libcurl (7.74.0-r1)
(4/4) Installing curl (7.74.0-r1)
Executing busybox-1.32.1-r3.trigger
OK: 15 MiB in 34 packages
/ # curl 10.244.0.12:8080
Hi, I'm Blue
/ # exit
```

To get blue IP:
```
kubectl describe pod blue-deployment-78bdc97dcd-4tbb8
Name:         blue-deployment-78bdc97dcd-4tbb8
Namespace:    default
Priority:     0     
Node:         myfirstcluster-control-plane/172.18.0.2
Start Time:   Wed, 03 Mar 2021 11:26:46 +0100
Labels:       app=server-blue     
              pod-template-hash=78bdc97dcd                                              
Annotations:  <none>                          
Status:       Running                 
IP:           10.244.0.12  
IPs:            
  IP:         10.244.0.12  
```

! Important:

Deployment containerPort and server ListenAndServe port must be the same


### Using a service:

* Define the service
* Apply the service
* Run the following commands to test:

```
kubectl exec -it green-deployment-5d8486d64f-4ntt8 -- sh
/ # apk add curl
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/community/x86_64/APKINDEX.tar.gz
(1/4) Installing brotli-libs (1.0.9-r3)
(2/4) Installing nghttp2-libs (1.42.0-r1)
(3/4) Installing libcurl (7.74.0-r1)
(4/4) Installing curl (7.74.0-r1)
Executing busybox-1.32.1-r3.trigger
OK: 15 MiB in 34 packages
/ # curl blue-service.default:8080
Hi, I'm Blue
/ # exit
```

## Task 4.2

Add ingress and ingress controller (kubernetes ingress-nginx) type NodePort.

Steps:

### 1st step - Build go binary
```
go build server-blue.go 
go build server-green.go 
```

### 2nd setp - Generate docker images
```
docker build -t server-blue . 
docker build -t server-green . 
```

### 3rd step - Generate kind-config and create kind cluster with this configuration. Delete previous clusters
```
kind delete cluster
kind create cluster --config=kind-config.yaml 
```

### 4th step - Load images in the cluster
```
kind load docker-image server-green:latest
kind load docker-image server-blue:latest
```

### 5th step - Apply deployments, services and ingress
```
kubectl apply -f blue-deployment.yaml
kubectl apply -f green-deployment.yaml
kubectl apply -f blue-service.yaml
kubectl apply -f green-service.yaml
kubectl apply -f ingress.yaml
```

! Important to add annotations in ingress.yaml,

### 6th step - Install ingress controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --set controller.service.type=NodePort,controller.service.nodePorts.http=30000
```

! Check extraPortMappings containerPort in kind-config to match value controller.service.nodePorts.http=30000.

### 7th step - Test connection:
```
curl localhost:8080/blue
Hi, I'm Blue
curl localhost:8080/green
Hi, I'm Green
```

### Ports order

Request:8080 -> 8080:kind-cluster:30000 -> 30000:ingress-controller:ingress:8080 -> 8080:services


## Task 4.3

Add ingress and ingress controller (kubernetes ingress-nginx) type LoadBalancer.

Same 1st to 4th step from task 4.2.

### 5th step - Apply deployments, services and ingress
```
kubectl apply -f blue-deployment.yaml
kubectl apply -f green-deployment.yaml
kubectl apply -f blue-service.yaml
kubectl apply -f green-service.yaml
kubectl apply -f ingress2.yaml
```

! Using ingress2.yaml without setting the host url.


### 6th step - Allow king using load balancer. 
Check [this](https://kind.sigs.k8s.io/docs/user/loadbalancer/).

```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml
docker network inspect -f '{{.IPAM.Config}}' kind
```
The output will contain a cidr such as 172.19.0.0/16. We want our loadbalancer IP range to come from this subclass. Mach the configMap.yaml addresses with the obtained cidr.
```
kubectl apply -f configMap.yaml
```

### 7th step - Install ingress controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

### 8th step - Get ingress controller external IP
```
kubectl get svc
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                        AGE
ingress-nginx-controller             LoadBalancer   10.96.67.21     172.18.255.200   80:31465/TCP,443:30825/TCP   12m
```

### 9th step - Test connection:
```
curl 172.18.255.200:80/blue
Hi, I'm Blue
curl 172.18.255.200:80/green
Hi, I'm Green
```

### Ports order

Request:80 -> 80:ingress-controller-type-loadbalancer:ingress:8080 -> 8080:services

