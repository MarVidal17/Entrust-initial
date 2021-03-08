# Task 6

Blue Green using [Istio](https://istio.io/latest/).
Working inside folder initial.

### Step 0. Install istio.

### Step 1. Create service accounts:
```
kubectl create serviceaccount green-account
kubectl create serviceaccount blue-account
kubectl get authorizationpolicy
```
### Step 2. Add serviceAccountName in deployments:

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