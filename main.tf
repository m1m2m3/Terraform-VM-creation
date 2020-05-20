provider "vsphere" {
  user           = "adm_akshaynamdev"
  password       = "Password1"
  vsphere_server = "ukdcl-ic-vcs01.test-lab.local"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "iac-lab"
}

data "vsphere_datastore" "datastore" {
  name          = "ESXi_IAC02"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "cls01/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "Existing-LAB-Network|AP-EXISTING-LAB|SERVICES-124-LAB"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "rhel-kickstart-test-20200519T111004"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_folder" "folder" {
  path          = "AkshayNamdev"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "rhel7_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 50
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
 } 
  
}

#ok
