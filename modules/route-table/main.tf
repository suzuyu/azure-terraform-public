# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
resource "azurerm_route_table" "table" {
  name                = var.table_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_route" "to_gw_route" {
  for_each            = toset(var.to_gw_routes_list)
  name                = "to_gw_route_${index(var.to_gw_routes_list, each.value) + 1}"
  resource_group_name = var.resource_group.name
  route_table_name    = azurerm_route_table.table.name
  address_prefix      = each.value
  next_hop_type       = "VirtualNetworkGateway"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association
resource "azurerm_subnet_route_table_association" "table" {
  for_each       = toset(var.enable_subnetsid_list)
  subnet_id      = each.value
  route_table_id = azurerm_route_table.table.id
}

