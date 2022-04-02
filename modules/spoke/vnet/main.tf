# VNET の作成
resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

# Subnet の作成
resource "azurerm_subnet" "main" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.address_prefix]
}

# Hub 接続
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "peer-${azurerm_virtual_network.main.name}-to-${var.remote_virtual_network_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}
