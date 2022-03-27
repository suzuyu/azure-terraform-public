variable "resource_group_name" {}

variable "location" {}

variable "virtual_network_name" {}

variable "address_space" {}

variable "subnets" {}

variable "remote_virtual_network_name" {}

variable "remote_virtual_network_id" {}

variable "use_remote_gateways" {
  type    = bool
  default = true
}
