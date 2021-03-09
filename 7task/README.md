# Task 7

0. Entendre diferencia entre deployment/statefulset/cronjob
1. Implementar un codi go que exposi un endpoint. Per cada crida a l'endpoint, aquest ha d'incrementar un contador guardat en un fitxer.
2. Desplegar un deployment fent servir el codi del punt anterior. El deployment ha de ser multireplica i compartir el mateix contador entre les diferents repliques. Juntament amb el deployment, hauras de crear un service.
3. Desplegar un statefulset amb diverses repliques fent servir el codi go anterior. Hauras de crear un headless service.
4. Implementar un codi go que simplement faci un print dient alguna cosa.
5. Desplegar un cronjob fent servir el codi del punt anterior.
6. Crear un helm chart que empaqueti tant el deployment, com l'statefulset i el cronjob

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