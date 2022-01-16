
module "hub-rg" {
  source = "../../../modules/hub-rg/"

  resource_group   = var.hub_resource_group
  environment_tags = var.hub_environment_tags
  location         = var.hub_location
  vnet_name        = var.hub_vnet_name
  address_space    = var.hub_address_space
  subnets = {
    GatewaySubnet = {
      address_prefix = var.hub_GatewaySubnet
    },
    AzureFirewallSubnet = {
      address_prefix = var.hub_AzureFirewallSubnet
    },
  }
}

output "hub_resource_group_name" {
  value = module.hub-rg.resource_group.name
}

output "hub_virtual_network_id" {
  value = module.hub-rg.virtual_network.id
}

output "hub_virtual_network_name" {
  value = module.hub-rg.virtual_network.name
}

module "hub-onprem-vpn" {
  source = "../../../modules/onprem-vpn/"

  resource_group   = module.hub-rg.resource_group
  environment_tags = var.hub_environment_tags
  subnet_id        = module.hub-rg.subnets["GatewaySubnet"].id

  vpn_name = var.vpn_name

  onprem_public_ip = var.onprem_public_ip
  shared_key       = var.shared_key # openssl rand -base64 24

  onprem_network_subnets_list = [
    var.onprem_bgp_neighbor_subnet,
  ]
  onprem_asn               = var.onprem_asn
  onprem_bgp_neighbor_addr = var.onprem_bgp_neighbor_addr

  bgp_asn = var.bgp_asn
}

output "hub-onprem-vpn-ip-address" {
  value = module.hub-onprem-vpn.onprem-vpn-ip-address
}
