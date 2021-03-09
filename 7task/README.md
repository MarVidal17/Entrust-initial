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

## 7.2. Deployment with shared volume

```
kubectl apply -f counter-deployment.yaml
```