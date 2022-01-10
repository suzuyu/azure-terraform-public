output "subnets" {
  value = azurerm_subnet.hub-subnet
}

output "resource_group" {
  value = azurerm_resource_group.hub-rg
}

output "virtual_network" {
  value = azurerm_virtual_network.hub-vnet
}
