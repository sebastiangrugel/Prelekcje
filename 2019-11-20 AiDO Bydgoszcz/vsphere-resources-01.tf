// Pobranie informacji o istniejącym datacenter z vCenter. Referencja: https://www.terraform.io/docs/providers/vsphere/d/datacenter.html
data "vsphere_datacenter" "primary-datacenter" {
  name = "BSB"
  }

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Management"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}

// Pobranie informacji o istniejącym hoscie przykad 1:1 z https://www.terraform.io/docs/providers/vsphere/d/host.html. Mona deklarować także grupę hostów przykład: https://github.com/sebastiangrugel/terraform/blob/master/Learning/vsphere_example1/modules/vsphere_resources.tf
  data "vsphere_host" "host" {
  name          = "esxi1.aido.local"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}


// Deklaracja istniejącego już datastore
data "vsphere_datastore" "datastore-large" {
  name          = "LocalDatastore1"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}


// Deklaracja istniejącego już datastore z ESXi2
data "vsphere_datastore" "datastore-large2" {
  name          = "LocalDatastore2"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}

data "vsphere_network" "siec" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}

/*
resource "vsphere_host" "host_esx02" {
  hostname = "esxi2.aido.local"
  username = "root"
  password = "soY!2zsdIU"
  datacenter =  "${data.vsphere_datacenter.primary-datacenter.id}"
  maintenance = false
}
*/


resource "vsphere_virtual_machine" "vm" {
  name             = "AiDO-pustaMaszyna${count.index + 1}"
  resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}" # lokalizacja w klastrze poza resource pool
  datastore_id     = "${data.vsphere_datastore.datastore-large2.id}"
  num_cpus = 2
  memory   = 256
  guest_id = "other3xLinux64Guest"
  count = 1
    wait_for_guest_ip_timeout = 0
  wait_for_guest_net_timeout = 0
    network_interface {
    network_id = "${data.vsphere_network.siec.id}"
  }
  disk {
    label = "disk0"
    size  = 5
  }
}



// ############################# TWORZENIE MASZYN WIRTUALNYCH Z TEMPLATE ###############################

// Zczytanie informacji na temat istniejącego 
data "vsphere_virtual_machine" "template_linux_1" {
#name = "${var.template_linux_centos}"
name = "centos7.7-template"
datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}

resource "vsphere_virtual_machine" "vm_template" {
count = 1
name             = "VM-template_${count.index + 1}"
resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}"
datastore_id     = "${data.vsphere_datastore.datastore-large2.id}"

num_cpus = 2
memory   = 1024
guest_id = "${data.vsphere_virtual_machine.template_linux_1.guest_id}"

network_interface {
    network_id   = "${data.vsphere_network.siec.id}"
    //adapter_type = "${data.vsphere_virtual_machine.template_linux_1.network_interface_types[0]}"
    adapter_type = "vmxnet3"
  }

disk {
    label = "disk0"
    size  = "${data.vsphere_virtual_machine.template_linux_1.disks.0.size}"
  }
# Additional disk
  disk {
    label = "disk1"
    size  = "5"
    unit_number = 1
  }

clone {
    template_uuid = "${data.vsphere_virtual_machine.template_linux_1.id}"


customize {
      linux_options {
        host_name = "centoshostname"
        #host_name = "${var.hostname}"
        domain    = "mojadomena.local"
             }

         network_interface {
        ipv4_address = "192.168.5.51"
        #ipv4_address = "${var.vm_mgt_ip}"
        ipv4_netmask = 24
      }     
      ipv4_gateway = "192.168.5.1"
      #ipv4_gateway = "${var.vm_gw}"
      #dns_server_list = "168.168.5.2"
      #dns_server_list = ["${var.vm_dns}"]
      
    }
}
wait_for_guest_ip_timeout = 0
wait_for_guest_net_timeout = 0
}