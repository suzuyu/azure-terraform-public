variable "resource_group_name" {}

variable "location" {}

variable "subnet_id" {}

variable "vpn_name" {}

variable "onprem_public_ip" {}

# variable "onprem_public_fqdn" {}

variable "shared_key" {}

variable "onprem_network_subnets_list" {}

variable "onprem_asn" {}

variable "onprem_bgp_neighbor_addr" {}

variable "bgp_asn" {}

variable "vpn_sku" {
  type    = string
  default = "VpnGw1"
}
