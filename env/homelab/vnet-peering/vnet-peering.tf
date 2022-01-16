
module "vnet-peering-hub-spoke-conn" {
  source = "../../../modules/hub-spoke-conn/"

  environment_tags = var.environment_tags

  hub_resource_group_name  = var.hub_resource_group_name
  hub_virtual_network_id   = var.hub_virtual_network_id
  hub_virtual_network_name = var.hub_virtual_network_name

  spoke_resource_groups = var.spoke_resource_groups
}
