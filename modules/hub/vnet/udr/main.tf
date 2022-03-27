# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route
resource "azurerm_route_table" "main" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "main" {
  for_each               = toset(var.to_subregion_destination_subnet_list)
  name                   = "to_subregion_${replace(each.value, "/", "_")}"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = each.value
  next_hop_in_ip_address = var.to_subregion_next_hop_address
  next_hop_type          = "VirtualAppliance"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association
resource "azurerm_subnet_route_table_association" "main" {
  for_each       = toset(var.subnets_id_list)
  subnet_id      = each.value
  route_table_id = azurerm_route_table.main.id
}
