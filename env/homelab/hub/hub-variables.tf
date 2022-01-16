## hub-rg
variable "hub_resource_group" {}

variable "hub_environment_tags" {}

variable "hub_location" {}

variable "hub_vnet_name" {}

variable "hub_address_space" {}

variable "hub_GatewaySubnet" {}

variable "hub_AzureFirewallSubnet" {}

## vpn
variable "vpn_name" {}

variable "onprem_public_ip" {}

variable "shared_key" {}

variable "onprem_bgp_neighbor_subnet" {}

variable "onprem_asn" {}

variable "onprem_bgp_neighbor_addr" {}

variable "bgp_asn" {}

## firewall
variable "firewall_name" {}