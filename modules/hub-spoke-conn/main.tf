# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  for_each                     = { for i in var.spoke_resource_groups : i.resource_group_name.name => i }
  name                         = "peer-hub-to-${each.value["virtual_network"].name}"
  resource_group_name          = var.hub_resource_group.name
  virtual_network_name         = var.hub_virtual_network_name
  remote_virtual_network_id    = each.value["virtual_network"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  for_each                     = { for i in var.spoke_resource_groups : i.resource_group_name.name => i }
  name                         = "peer-${each.value["virtual_network"].name}-to-hub"
  resource_group_name          = each.value["resource_group_name"].name
  virtual_network_name         = each.value["virtual_network"].name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}
