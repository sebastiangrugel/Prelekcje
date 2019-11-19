## Masz pytania ? lub potrzebujesz pomocy w projekcie ? Zachęcam do kontaktu na sebastian@akademiadatacenter.pl
## Autor: Sebastian Grugel

#Workaround z uwagi na to że przy wykorzystaniu datacenter tworzonego przez resource niestety nie jest ten obiekt widoczny (do sprswdzenia pozniej). Zczytanie datacenter poprzez parametr data umozliwiło dodanie hostów do vCentra. Nie jest to metoda jeszcze wspierana także moze przy kolejnej wersji providera będzie to działało. 
data "vsphere_datacenter" "moje_datacenter_dla_hostow" {
  name = "Terraform AiDO DC"
  depends_on = ["vsphere_datacenter.moje_datacenter"]
  }

# Tworzenie datacenter na potrzeby dodawanych hostów
resource "vsphere_datacenter" "moje_datacenter" {
  name       = "Terraform AiDO DC"
}


// Pobranie informacji o istniejącym datacenter z vCenter. Referencja: https://www.terraform.io/docs/providers/vsphere/d/datacenter.html
data "vsphere_datacenter" "primary-datacenter" {
  name = "BSB"
  }

  data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Management"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}

// Pobranie informacji o istniejącym hoscie przykad 1:1 z https://www.terraform.io/docs/providers/vsphere/d/host.html. Mona deklarować także grupę hostów przykład: https://github.com/sebastiangrugel/terraform/blob/master/Learning/vsphere_example1/modules/vsphere_resources.tf
 # data "vsphere_host" "host" {
 # name          = "esxi1.aido.local"
 # datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
#}


#Deklaracja istniejącego już datastore
data "vsphere_datastore" "datastore-large1" {
  name          = "LocalDatastore1"
  datacenter_id = "${data.vsphere_datacenter.primary-datacenter.id}"
}


// Deklaracja istniejącego już datastore z ESXi2. Wykona się to dopiero jak ESXi2 zostanie dodany do DC.
data "vsphere_datastore" "datastore-large2" {
  name          = "LocalDatastore2"
  #datacenter_id = "${vsphere_datacenter.moje_datacenter.id}" - nie działa.Poniżej workaround.
  datacenter_id = "${data.vsphere_datacenter.moje_datacenter_dla_hostow.id}"
  depends_on = ["vsphere_host.host_esx02"]
}

data "vsphere_network" "siec" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.moje_datacenter_dla_hostow.id}"
   depends_on = ["vsphere_host.host_esx02"]

}