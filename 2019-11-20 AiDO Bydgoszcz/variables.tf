## Masz pytania ? lub potrzebujesz pomocy w projekcie ? Zachęcam do kontaktu na sebastian@akademiadatacenter.pl
## Autor: Sebastian Grugel

variable "vc_user" {
  description = "vCloud user"
}

variable "vc_pass" {
  description = "vCloud pass"
}

variable "vc_allow_unverified_ssl" {
  description = "vCloud SSL"
}

variable "vc_max_retry_timeout" {
  description = "vCloud Timeout"
}

variable "vc_vsphere_server" {
  description = "vCenter FQDN"
}

variable "esxi_password" {
  description = "Password to ESXi"
  
}

# Zmienne, których wartości są konfigurowalne:

#variable "vm_mgt_ip" {
#  type = "string"
#  default = "192.168.5.101"
# }

 
