
module "hub-rg" {
  source = "../../modules/hub-rg/"

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

module "hub-onprem-vpn" {
  source = "../../modules/onprem-vpn/"

  resource_group   = module.hub-rg.resource_group
  environment_tags = var.hub_environment_tags
  subnet_id        = module.hub-rg.subnets["GatewaySubnet"].id

  vpn_name = var.vpn_name

  onprem_public_ip = var.onprem_public_ip
  shared_key       = var.shared_key # openssl rand -base64 24

  # onprem_network_subnets_list = var.onprem_network_subnets_list
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

# module "hub-az-firewall" {
#   source = "../../modules/az-firewall/"

#   resource_group   = module.hub-rg.resource_group
#   environment_tags = var.hub_environment_tags
#   subnet_id        = module.hub-rg.subnets["AzureFirewallSubnet"].id

#   firewall_name = var.firewall_name

#   depends_on = [
#     module.hub-rg,
#   ]
# }

module "hub-hub-spoke-conn" {
  source = "../../modules/hub-spoke-conn/"

  environment_tags = var.hub_environment_tags

  hub_resource_group       = module.hub-rg.resource_group
  hub_virtual_network_name = module.hub-rg.virtual_network.name
  hub_virtual_network_id   = module.hub-rg.virtual_network.id

  spoke_resource_groups = [
    {
      resource_group_name = module.spoke1-rg.resource_group
      virtual_network     = module.spoke1-rg.virtual_network
    },
    {
      resource_group_name = module.spoke2-rg.resource_group
      virtual_network     = module.spoke2-rg.virtual_network
    },
  ]
}
