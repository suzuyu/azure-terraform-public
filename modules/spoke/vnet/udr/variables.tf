variable "resource_group_name" {}

variable "location" {}

variable "subnet_id" {}

variable "to_hub_destination_subnet_list" {}

variable "to_hub_next_hop_address" {}

variable "route_table_name" {
  type    = string
  default = "default_route_table"
}
