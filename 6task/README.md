# Task 6

Blue Green using [Istio](https://istio.io/latest/).
Working inside folder initial.

### Uninstall isito and install commands

With enableAutoMtls set to false.

Uninstall:
```
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f - 
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
```

Install again:
```
istioctl install --set profile=default --set hub=gcr.io/istio-release --set values.global.proxy.privileged=true
```

Label again (check READY numbers, they are the number of containers that each pod has):
```
kubectl delete pods --all
kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
blue-7b9577b875-cgh7m    1/1     Running   0          21s
green-5654bf8595-cwk99   1/1     Running   0          21s
kubectl label namespace default istio-injection=enabled
kubectl delete pods --all                              
kubectl get pods                                       
NAME                     READY   STATUS    RESTARTS   AGE
blue-7b9577b875-f7lj5    2/2     Running   0          12s
green-5654bf8595-c6bj9   2/2     Running   0          12s
```

## Authorization Policies

### Step 1. Create service accounts:
```
kubectl create serviceaccount green-account
kubectl create serviceaccount blue-account
```

### Step 2. Add serviceAccountName in deployments and apply them again:

```
    spec:
      serviceAccountName: green-account
```

### Step 3. Create and apply general authorization policy:

! Add app labels to do the match between auth policies and servicies and deployments.

```
kubectl apply -f 6task/istio-general.yaml
kubectl exec -it blue-7b9577b875-9pqhc -- sh
/ # curl green-service.default:8080
RBAC: access denied
/ # exit
kubectl exec -it  green-74cd95f57c-vrf9x -- sh                                
/ # curl blue-service.default:8080
RBAC: access denied
/ # exit 
```

### Step 4. Create and apply blue authorization policy:

Allow only green service to send requests to blue services.

```
kubectl apply -f 6task/istio-general.yaml
kubectl exec -it  green-74cd95f57c-vrf9x -- sh                                
/ # curl blue-service.default:8080
Hi, I'm Blue
/ # exit 
kubectl exec -it blue-7b9577b875-9pqhc -- sh
/ # curl green-service.default:8080
RBAC: access denied
/ # exit
```

## MTLS and Peer Authentication

Check:

* [MTLS Wiki](https://en.wikipedia.org/wiki/Mutual_authentication)
* [Istio MTLS concepts](https://istio.io/latest/docs/concepts/security/#mutual-tls-authentication)
* [Istio Peer Auth concepts](https://istio.io/latest/docs/concepts/security/#peer-authentication)
* [Istio Peer Auth and MTLS application](https://istio.io/latest/docs/reference/config/security/peer_authentication/)


### Step 0

* Apply auth policies that allow blue-green talk.

### Step 1. Check if works when mtls in green disabled

```
kubectl apply -f 6task/peerauth-green.yaml
kubectl exec -it green-5654bf8595-c6bj9 -- sh
/ # curl blue-service:8080
Hi, I'm Blue
/ # exit
kubectl exec -it blue-7b9577b875-f7lj5 -- sh
/ # curl green-service:8080
Hi, I'm Green
/ # exit
```

### Step 2. Check again with mtls in blue strict

```
kubectl apply -f 6task/peerauth-blue.yaml
kubectl exec -it green-5654bf8595-c6bj9 -- sh
/ # curl blue-service:8080
upstream connect error or disconnect/reset before headers. reset reason: connection failure, transport failure reason: TLS error
/ # exit
kubectl exec -it blue-7b9577b875-f7lj5 -- sh
/ # curl green-service:8080
Hi, I'm Green
/ # exit
```

### Step 3. Check again with mtls in both strict

Change green mtls mode to STRICT, save and apply.

```
kubectl apply -f 6task/peerauth-green.yaml
kubectl exec -it green-5654bf8595-c6bj9 -- sh
/ # curl blue-service:8080
Hi, I'm Blue
/ # exit
kubectl exec -it blue-7b9577b875-f7lj5 -- sh
/ # curl green-service:8080
Hi, I'm Green
/ # exit
```
