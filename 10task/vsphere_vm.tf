data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          =  "/${var.datacenter_name}/host/${var.cluster_name}/Resources/${var.resource_pool_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder = var.folder  

  num_cpus = var.ncpu
  memory   = var.ram
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {

      linux_options {
        host_name = var.vm_name
        domain = var.domain
      }

      network_interface {
        ipv4_address = var.vm_ip
        ipv4_netmask = 24
      }

      ipv4_gateway = var.gateway
      dns_server_list = var.dns
  
    }
  }

  disk {
    label = "disk0"
    size  = var.disk_space
  }
}