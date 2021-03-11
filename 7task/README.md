# Task 7

0. Entendre diferencia entre deployment/statefulset/cronjob
1. Implementar un codi go que exposi un endpoint. Per cada crida a l'endpoint, aquest ha d'incrementar un contador guardat en un fitxer.
2. Desplegar un deployment fent servir el codi del punt anterior. El deployment ha de ser multireplica i compartir el mateix contador entre les diferents repliques. Juntament amb el deployment, hauras de crear un service.
3. Desplegar un statefulset amb diverses repliques fent servir el codi go anterior. Hauras de crear un headless service.
4. Statefulset vs deployments
5. Implementar un codi go que simplement faci un print dient alguna cosa.
6. Desplegar un cronjob fent servir el codi del punt anterior.
7. Crear un helm chart que empaqueti tant el deployment, com l'statefulset i el cronjob

## 7.1. Go code and cluster created

```
go build counter.go
docker build -t counter .
kind create cluster
kind load docker-image counter:latest
```

## 7.2. Deployment with shared counter for all pods

Read Kubernetes in action by Marko Luksa section 6.6.3. Dynamic provisioning without specifying a storage class.

```
kubectl apply -f counter-pvc.yaml
kubectl get pvc
NAME          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
counter-pvc   Bound    pvc-da5d4570-eb5c-45f3-8963-5e1a6f074a37   1Gi        RWO            standard       3s
```
Check that the pvc status is Bound.

```
kubectl apply -f counter-deployment.yaml
kubectl apply -f counter-service.yaml
```

Check that pods are correctly running.

Test the system, open two pod shells.

From pod #1:
```
kubectl exec -it counter-deployment-bcd4d595-fqc6q -- sh
# curl counter-service:8080
Counter incremented:  1
# curl counter-service:8080                         
Counter incremented:  2
```
From pod #2:
```
kubectl exec -it counter-deployment-bcd4d595-h9zwf -- sh
# curl counter-service:8080
Counter incremented:  3
```
From pod #1:
```
# curl counter-service:8080
Counter incremented:  4
# curl counter-service:8080                         
Counter incremented:  5
```
From pod #2:
```
# curl counter-service:8080
Counter incremented:  6
# curl counter-service:8080
Counter incremented:  7
# curl counter-service:8080
Counter incremented:  8
```
From pod #1:
```
# curl counter-service:8080
Counter incremented:  9
```

Check if deleting the deployment the counter continues or it starts again.

```
kubectl get deployment
kubectl delete deployment counter-deployment
kubectl apply -f counter-deployment.yaml
kubectl get pods
kubectl exec -it counter-deployment-bcd4d595-hqdbp -- sh
# curl counter-service:8080
Counter incremented:  10
```

## 7.3. Statefulset

Desplegar un statefulset amb diverses repliques fent servir el codi go anterior. Hauras de crear un headless service.

Check the differences between the counter-service.yaml and counter-hlservice.yaml.

```
kubectl delete deployment counter-deployment
kubectl delete services counter-service
kubectl apply -f counter-statefulset.yaml
kubectl apply -f counter-hlservice.yaml
```

Check that the service is working:

```
kubectl get pods                              
NAME                    READY   STATUS    RESTARTS   AGE
counter-statefulset-0   1/1     Running   0          4s
counter-statefulset-1   1/1     Running   0          3s
counter-statefulset-2   1/1     Running   0          2s
kubectl exec -it counter-statefulset-0 -- sh
# curl counter-service:8080
Counter incremented:  11
```

Check the specific pod IPs to request directly to them:

```
kubectl run dnsutils --image=tutum/dnsutils --generator=run-pod/v1 --command -- sleep infinity
pod/dnsutils created    
kubectl exec dnsutils nslookup counter-service
Server:         10.96.0.10
Address:        10.96.0.10#53

Name:   counter-service.default.svc.cluster.local
Address: 10.244.0.18
Name:   counter-service.default.svc.cluster.local
Address: 10.244.0.17
Name:   counter-service.default.svc.cluster.local
Address: 10.244.0.19

kubectl exec -it counter-statefulset-0 -- sh 
# curl 10.244.0.19:8080
Counter incremented:  12
# curl counter-statefulset-1.counter-service:8080
Counter incremented:  13
```

See that the counter continues as it uses the same default persistent storage as before.

### Persistent volumes

If in counter-statefulset we have the following code inside the spec.templates.spec:
```yaml
volumes:
- name: counter-pv-storage
persistentVolumeClaim:
    claimName: counter-pvc
```
only persistent volume claim will be created for the three recplicas. 

Insted, if we have the following code inside the  kube:
```yaml
  volumeClaimTemplates:
  - metadata:
      name: counter-pv-storage
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
```

one volume claim will be created for each replica and pointing to different storages:

```
kubectl delete pvc counter-pvc
kubectl delete statefulset counter-statefulset
kubectl apply -f counter-statefulset.yaml
kubectl get  pods
NAME                    READY   STATUS    RESTARTS   AGE
counter-statefulset-0   1/1     Running   0          10s
counter-statefulset-1   1/1     Running   0          6s
counter-statefulset-2   1/1     Running   0          3s
dnsutils                1/1     Running   1          18h
kubectl get pvc
NAME                                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
counter-pv-storage-counter-statefulset-0   Bound    pvc-e1a3071d-5326-4d7c-9139-57d04e5b1213   1Gi        RWO            standard       68s
counter-pv-storage-counter-statefulset-1   Bound    pvc-4f20145e-0f05-4ee4-b506-fbc3ee788f44   1Gi        RWO            standard       64s
counter-pv-storage-counter-statefulset-2   Bound    pvc-e372bbbf-720c-4926-92be-e1328385bd2b   1Gi        RWO            standard       61s
kubectl exec -it counter-statefulset-0 -- sh
# curl counter-service:8080
Counter incremented:  1
# curl counter-service:8080
Counter incremented:  2
# curl counter-statefulset-1.counter-service:8080
Counter incremented:  3
# curl counter-statefulset-2.counter-service:8080
Counter incremented:  1
# curl counter-statefulset-0.counter-service:8080
Counter incremented:  1
# curl counter-service:8080
Counter incremented:  2
```

Now, when pointing the service we do not know which pod we will reach.

Check what happens when deleting one pod (curl counter-statefulset-1), if the counter continues (increments to 4).

```
kubectl delete pod counter-statefulset-1
kubectl exec -it counter-statefulset-0 -- sh
# curl counter-statefulset-1.counter-service:8080
Counter incremented:  4
```

When deleting the counter statefulset the persitent counter claims persist:
```
kubectl delete statefulsets counter-statefulset
kubectl get pvc                   
NAME                                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
counter-pv-storage-counter-statefulset-0   Bound    pvc-f94a9cb3-efff-4395-857d-aa15ff038a2f   1Gi        RWO            standard       30s
counter-pv-storage-counter-statefulset-1   Bound    pvc-8872e8a9-cb2f-4a37-b667-7fb2cb2fdc7c   1Gi        RWO            standard       26s
counter-pv-storage-counter-statefulset-2   Bound    pvc-ac3ea46d-7739-4839-9232-8c4817d7b6ac   1Gi        RWO            standard       23s
```

## 7.4. Deployment vs. Statefulset behaviour

### Nslookup in deployment

Let's check nslookup in deployment instead of statefulset:

```
kubectl delete statefulset counter-statefulset
kubectl delete services counter-service
kubectl apply -f counter-deployment.yaml
kubectl apply -f counter-service.yaml
```

```
kubectl get svc 
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
counter-service   ClusterIP   10.108.82.200   <none>        8080/TCP   14s
kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP    28h

kubectl exec dnsutils nslookup counter-service             
Server:         10.96.0.10
Address:        10.96.0.10#53

Name:   counter-service.default.svc.cluster.local
Address: 10.108.82.200
kubectl get pods
kubectl describe pod counter-deployment-bcd4d595-mgd7p 
...
IP:           10.244.0.7
...
kubectl exec -it counter-deployment-bcd4d595-r8bk8 -- sh
# curl 10.244.0.7:8080
Counter incremented:  14
# curl counter-deployment-bcd4d595-mgd7p.counter-service:8080
curl: (6) Could not resolve host: counter-deployment-bcd4d595-mgd7p.counter-service
# curl counter-deployment-bcd4d595-mgd7p:8080
curl: (6) Could not resolve host: counter-deployment-bcd4d595-mgd7p
```
See that you can not access through the pod name.

Check new name and new IP if deleting the counter-deployment-bcd4d595-mgd7p pod:
```
kubectl delete pod counter-deployment-bcd4d595-mgd7p 
kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
counter-deployment-bcd4d595-6sfmx   1/1     Running   0          10s
counter-deployment-bcd4d595-r8bk8   1/1     Running   1          16h
counter-deployment-bcd4d595-zlb64   1/1     Running   1          16h
kubectl describe pod counter-deployment-bcd4d595-6sfmx                                                      
...                                                                                                            
IP:           10.244.0.9
...
```

### Persistent volumes claims

If we try to change the counter-deployment.yaml to add:
```yaml
  volumeClaimTemplates:
  - metadata:
      name: counter-pv-storage
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
```

We try to deploy:
```
kubectl apply -f counter-deployment.yaml 
error: error validating "counter-deployment.yaml": error validating data: ValidationError(Deployment.spec): unknown field "volumeClaimTemplates" in io.k8s.api.apps.v1.DeploymentSpec; if you choose to ignore these errors, turn validation off with --validate=false
```
The deployment spec does not have volumeClaimTemplates.


