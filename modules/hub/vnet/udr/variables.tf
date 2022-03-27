variable "resource_group_name" {}

variable "location" {}

variable "subnets_id_list" {}

variable "to_subregion_destination_subnet_list" {}

variable "to_subregion_next_hop_address" {}

variable "route_table_name" {
  type    = string
  default = "default_route_table"
}
