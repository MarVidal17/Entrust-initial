# VSphere Server Info
variable "vsphere_user" {
    default = "svc_pking@corporate.datacard.com"
}
variable "vsphere_pwd" {
    default = "Terraform@pkihub2020!!!!"
}
variable "vsphere_server" {
    default = "mmspvcsa01.corporate.datacard.com"
}
variable "datacenter_name" {
    default = "BCN"
}
variable "cluster_name" {
    default = "dbcn"
}
variable "datastore_name" {
    default = "dbcn"
}
variable "resource_pool_name" {
    default = "dbcn_PKIHUB"
}
variable "network_name" {
    default = "dbcn-VLAN27"
}
variable "template_name" {
    default = "dbcnpkingtemplate90"
}

variable "folder" {
    default = "dbcn/dbcn_PKIHUB"
}
variable "domain" {
    default = "entrustdatacard.com"
}
variable "name_prefix" {
    default = "dbcnpking"
}

# VM name
variable "vm_name" {
    default = "dbcnpkingtestmar96"
}

# VM IP network prefix
variable "ip_network_prefix" {
    default = "10.34.22"
}

# VM host IP
variable "vm_ip" {
    default = "10.34.22.96"
}

# VM default gateway and DNS servers
variable "gateway" {
    default = "10.34.22.1"
}
variable "dns" {
    default = [ "10.1.4.28", "10.1.4.29" ]
}

# VM vCPU number
variable "ncpu" {
    default = 4
}

# VM RAM memory (in MB)
variable "ram" {
    default = 8192
}

#VM DISK space (in GB)
variable "disk_space" {
    default = 128
}