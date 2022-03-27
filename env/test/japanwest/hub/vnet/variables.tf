variable "resource_group_name" {}

variable "location" {
  type    = string
  default = "japanwest"
}

variable "virtual_network_name" {}

variable "address_space" {}

variable "to_subregion_next_hop_address" {}

variable "subnets" {}

variable "to_subregion_destination_subnet_list" {}

variable "vpn_name" {}

# variable "onprem_public_ip" {}

# variable "shared_key" {}

# variable "onprem_bgp_neighbor_subnet" {}

# variable "onprem_asn" {}

# variable "onprem_bgp_neighbor_addr" {}

# variable "bgp_asn" {}

variable "subregion_virtual_network_name" {}

variable "subregion_virtual_network_id" {}

variable "vpn_sku" {
  type    = string
  default = "Basic"
}

variable "route_table_name" {
  type    = string
  default = "to_subregion"
}
