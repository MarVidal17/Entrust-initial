# Task 9

Desplegar una infraestructura composada basicament per una VPC amb dues subnets (publica i privada),
i muntar un escenari amb un servidor go simple tal que si es troba allotjat en la subnet publica es
pugui conectar a ell desde internet, i si esta a la subnet privada no, tot i que la subnet privada
ha de poder sortir a internet.

hauras de fer servir provisioners per tal de passar fitxer, scripts i el q et calgui per compilar el server i executarlo

si vols primer nomes monta la maquina de la  subnet publica, ja que et sira mes facil i crec q et caldra per muntar la maquina a la subnet privada


## 9.1. Server deployed in public instance

1. Login from terminal to AWS
2. Go into one_instance folder
2. Revise variable file vars.tf
3. Init terraform:
```
terraform init
```
4. Plan terraform and apply:
```
terraform plan -out terraform.out
terraform apply terraform.out
```
5. Check is working using istance public IP:
```
curl 54.76.135.245
Hi, I'm a Go server listening on port 80
```
6. To destroy all the services created:
```
terraform destroy
```

## 9.2. Server deployed in private instance

1. Login from terminal to AWS
2. Go into two_instance folder
2. Revise variable file vars.tf
3. Init terraform:
```
terraform init
```
4. Plan terraform and apply:
```
terraform plan -out terraform.out
terraform apply terraform.out
```
5. Check is working using going into the bastion and doing curl to the server private IP:
```
ssh ec2-user@ec2-52-51-115-53.eu-west-1.compute.amazonaws.com
[ec2-user@ip-10-0-0-108 ~]$ curl 10.0.1.98
Hi, I'm a Go server listening on port 80
```
6. To destroy all the services created:
```
terraform destroy
```