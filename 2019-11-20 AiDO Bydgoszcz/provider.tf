// Blok odpowiedzialny za łączenie z vCenter
provider "vsphere" {
  user                 = "${var.vc_user}"
  password             = "${var.vc_pass}"
  vsphere_server       = "${var.vc_vsphere_server}"
  allow_unverified_ssl = true
}
//
