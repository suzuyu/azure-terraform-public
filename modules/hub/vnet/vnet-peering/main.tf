# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "hub-to-hub" {
  name                         = "peer-${var.virtual_network_name}-to-${var.remote_virtual_network_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.virtual_network_name
  remote_virtual_network_id    = var.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
