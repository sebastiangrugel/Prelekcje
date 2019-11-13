data "vsphere_datacenter" "moje_datacenter" {
  name = "BSB"
  }

##test
variable "hosts" {
  default = ["esxi2.aido.local","esxi3.aido.local"]
    type = "list"
}

resource "vsphere_host" "host_esx02" {
  hostname = "esxi2.aido.local"
  username = "root"
  password = "soY!2zsdIU"
  datacenter = "${data.vsphere_datacenter.moje_datacenter.id}"
  maintenance = false
}

resource "vsphere_host" "host_esx03" {
  hostname = "esxi3.aido.local"
  username = "root"
  password = "soY!2zsdIU"
  datacenter = "${data.vsphere_datacenter.moje_datacenter.id}"
  maintenance = false
}



resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "Terraform_Cluster-AiDO"
  datacenter_id   = "${data.vsphere_datacenter.moje_datacenter.id}"
  #host_system_ids = ["${data.vsphere_host.hosts.*.id}"]
  host_system_ids = ["${vsphere_host.host_esx02.id}","${vsphere_host.host_esx03.id}"]

  
  drs_enabled          = true
  drs_automation_level = "fullyAutomated"
  ha_enabled = false
  force_evacuate_on_destroy = true
}
