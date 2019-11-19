variable "hosts" {
  default = ["esxi2.aido.local","esxi3.aido.local"]
    type = "list"
}
## Masz pytania ? lub potrzebujesz pomocy w projekcie ? Zachęcam do kontaktu na sebastian@akademiadatacenter.pl
## Autor: Sebastian Grugel

resource "vsphere_host" "host_esx02" {
  hostname = "esxi2.aido.local"
  username = "root"
  password = "${var.esxi_password}"
  datacenter = "${data.vsphere_datacenter.moje_datacenter_dla_hostow.id}"
  maintenance = false
 #depends_on = ["data.vsphere_datacenter.moje_datacenter_dla_hostow"]
depends_on = ["vsphere_datacenter.moje_datacenter"]
}

resource "vsphere_host" "host_esx03" {
  hostname = "esxi3.aido.local"
  username = "root"
  password = "${var.esxi_password}"
  datacenter = "${data.vsphere_datacenter.moje_datacenter_dla_hostow.id}"
  maintenance = false
#depends_on = ["data.vsphere_datacenter.moje_datacenter_dla_hostow"]
depends_on = ["vsphere_datacenter.moje_datacenter"]
}



resource "vsphere_compute_cluster" "compute_cluster_t" {
  name            = "Terraform_Cluster-AiDO"
   #datacenter_id   = "${vsphere_datacenter.moje_datacenter.id}" - powinno a nie działa. Do zweryfikowania.
  datacenter_id = "${data.vsphere_datacenter.moje_datacenter_dla_hostow.id}"
  #host_system_ids = ["${data.vsphere_host.hosts.*.id}"] - pare miesięcy temu działało.Do zweryfikowania.
  host_system_ids = ["${vsphere_host.host_esx02.id}","${vsphere_host.host_esx03.id}"] #workaround na sztywno ale działa.
  drs_enabled          = true
  drs_automation_level = "fullyAutomated"
  ha_enabled = false
  force_evacuate_on_destroy = true
  depends_on = ["vsphere_datacenter.moje_datacenter"]
}
