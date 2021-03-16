# Task 10

Create with terraform a vsphere machine.

https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine

6 tipus de data: vsphere_datacenter, vsphere_compute_cluster, vsphere_datastore, vsphere_resource_pool, vsphere_network i el resource de la vm que es: vsphere_virtual_machine

defineixis un output x coneixer la ip de la maquina

la vm_ip hauries de vigilar que no estigui ocupada
per checkearho entres a la web del vsphere
i el nom de la vm sempre posem al final l'ultim cap de la ip
si es 10.34.22.96, doncs el nom es <algo>96

1. Configure ssh pubkic key in virtual machine template.

2. Write terraform provider, data, variables, resources and outputs. Init, plan and apply terraform.
```
terraform init
terraform plan -out terraform.out
terraform apply terraform.out
```

3. Check it is working:
```
ssh sysadmin@10.34.22.96                                           
 sysadmin@dbcnpkingtestmar96  ~  exit
Shared connection to 10.34.22.96 closed.
```

4. Destroy:
```
terraform destroy
```