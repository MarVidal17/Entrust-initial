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

AWS util doc [here](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html).
