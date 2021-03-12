# Task 8

Create a cluster in EKS in AWS.

1. Import public ssh key in EC2 Key pairs in AWS.
2. Create the ClusterConfig with a small instance type and allow ssh using public key.
3. Deploy the cluster:
```
eksctl create cluster -f cluster.yaml
```

4. Check config to see where kubectl is pointing:
```
cd ~/.kube
ls
cache  config  config.eksctl.lock  http-cache
cat config
```

5. Push required images in ECR for deployment and statefulset containers.

AWS util doc [here](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html) and [here]().

Retrieve an authentication token and authenticate your Docker client to your registry:
```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 345070817929.dkr.ecr.eu-west-1.amazonaws.com
```

See if images are built the images. If they are not build, build them.
```
docker images                         
REPOSITORY     TAG       IMAGE ID       CREATED        SIZE
print-hour     latest    cdc05e74c6eb   21 hours ago   864MB
counter        latest    739cb3e8b577   2 days ago     868MB
```

Tag your image so you can push the image to this repository:
```
docker tag cdc05e74c6eb 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs:print-hour                         
docker tag 739cb3e8b577 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs:counter  
```

See that in this special case we are using one repository for two different images, and differenciate them using tags.

Push these images to ECR:
```
docker push 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs:print-hour                                     
docker push 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs:counter
```

Change the repository and tag names of values.yaml of the helm package.
```yaml
image:
  repository: 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs
  tag: "counter"
cronjob:
  image:
    repository: 345070817929.dkr.ecr.eu-west-1.amazonaws.com/mvs
    tag: "print-hour"
```

Install the helm package and check the pods:
```
helm install -f task7-helm/values.yaml task7-test ./task7-helm/
kubectl get pods
NAME                                  READY   STATUS      RESTARTS   AGE
counter-deployment-5d8464f844-2mxjg   1/1     Running     0          2m2s
counter-deployment-5d8464f844-fz82j   1/1     Running     0          2m2s
counter-deployment-5d8464f844-q8lvq   1/1     Running     0          2m2s
counter-statefulset-0                 1/1     Running     0          2m3s
counter-statefulset-1                 1/1     Running     0          90s
counter-statefulset-2                 1/1     Running     0          73s
hello-1615547820-5pq7b                0/1     Completed   0          78s
hello-1615547880-bdckr                0/1     Completed   0          18s
```