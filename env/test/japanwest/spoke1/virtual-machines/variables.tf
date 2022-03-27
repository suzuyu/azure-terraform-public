variable "resource_group_name" {}

variable "location" {
  type    = string
  default = "japanwest"
}

## vm
variable "spoke_vm1_name" {}

variable "spoke_vm1_size" {}

variable "spoke_vm1_admin_username" {}

variable "spoke_vm1_admin_password" {}

variable "spoke_vm1_os_disk_type" {}

variable "spoke_vm1_publisher" {
  default = "microsoftwindowsdesktop"
}

variable "spoke_vm1_offer" {
  default = "windows-11"
}

variable "spoke_vm1_sku" {
  default = "win11-21h2-pro"
}


variable "spoke_allow_external_source_address_prefixes" {}

variable "spoke_vm1_subnet_id" {}
