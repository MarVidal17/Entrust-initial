# Task 10

Create with terraform a vsphere machine.

https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine

6 tipus de data: vsphere_datacenter, vsphere_compute_cluster, vsphere_datastore, vsphere_resource_pool, vsphere_network i vsphere_virtual_machine (template) + el resource de la vm que és: vsphere_virtual_machine.

Definir un output x coneixer la ip de la maquina.


Variable vm_ip hauries de vigilar que no estigui ocupada. Fer el check entrant  a la web del vsphere.
Nom de la vm sempre posem al final l'últim cap de la ip, si es 10.34.22.96, doncs el nom és algo96.

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