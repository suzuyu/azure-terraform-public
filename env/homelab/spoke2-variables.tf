## spoke2-rg
variable "spoke2_resource_group" {}

variable "spoke2_environment_tags" {}

variable "spoke2_location" {}

variable "spoke2_vnet_name" {}

variable "spoke2_address_space" {}

variable "spoke2_subnet1" {}

variable "spoke2_vm1_name" {}

variable "spoke2_vm1_size" {}

variable "spoke2_vm1_admin_username" {}

variable "spoke2_vm1_admin_password" {}

variable "spoke2_vm1_os_disk_type" {}

variable "spoke2_vm1_publisher" {
  default = "microsoftwindowsdesktop"
}

variable "spoke2_vm1_offer" {
  default = "windows-11"
}

variable "spoke2_vm1_sku" {
  default = "win11-21h2-pro"
}

