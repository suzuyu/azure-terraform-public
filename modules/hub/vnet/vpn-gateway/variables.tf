variable "resource_group_name" {}

variable "location" {}

variable "subnet_id" {}

# vpn
variable "vpn_name" {}

# variable "onprem_public_ip" {}

# variable "shared_key" {}

# variable "onprem_bgp_neighbor_subnet" {}

# variable "onprem_asn" {}

# variable "onprem_bgp_neighbor_addr" {}

# variable "bgp_asn" {}

variable "vpn_sku" {}

variable "enable_bgp" {
  type    = bool
  default = false
}
