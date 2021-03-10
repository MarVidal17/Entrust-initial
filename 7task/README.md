# Task 7

0. Entendre diferencia entre deployment/statefulset/cronjob
1. Implementar un codi go que exposi un endpoint. Per cada crida a l'endpoint, aquest ha d'incrementar un contador guardat en un fitxer.
2. Desplegar un deployment fent servir el codi del punt anterior. El deployment ha de ser multireplica i compartir el mateix contador entre les diferents repliques. Juntament amb el deployment, hauras de crear un service.
3. Desplegar un statefulset amb diverses repliques fent servir el codi go anterior. Hauras de crear un headless service.
4. En lloc de fer servir un volum compartit entre les diferents replicas, fes servir un volum x replica (aquesta prova fela tant amb el deployment com amb els statefulsets). No hauria d'implicar gaire canvi del q tens. Hauries d'observar un comportament diferent al atacar al service del deployment vs al atacar el headles service dels statefulset.
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
```

See that the counter continues as it uses the same default persistent storage as before.

Let's check nslookup in deployment instead of statefulset:
```
kubectl delete statefulset counter-statefulset
kubectl delete services counter-service
kubectl apply -f counter-deployment.yaml
kubectl apply -f counter-service.yaml
```


## 7.4. Deployment vs. Statefulset behaviour

En lloc de fer servir un volum compartit entre les diferents replicas, fes servir un volum x replica (aquesta prova fela tant amb el deployment com amb els statefulsets). No hauria d'implicar gaire canvi del q tens. Hauries d'observar un comportament diferent al atacar al service del deployment vs al atacar el headles service dels statefulset.

EmptyDir volume storage information [here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/).


