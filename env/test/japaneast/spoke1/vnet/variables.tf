variable "resource_group_name" {}

variable "location" {
  type    = string
  default = "japaneast"
}

variable "virtual_network_name" {}

variable "address_space" {}

variable "subnets" {}

variable "hub_virtual_network_name" {}

variable "hub_virtual_network_id" {}

variable "to_hub_destination_subnet_list" {}

variable "to_hub_next_hop_address" {}

variable "route_table_name" {
  type    = string
  default = "default_route_table"
}
