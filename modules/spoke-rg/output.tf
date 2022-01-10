output "subnets" {
  value = azurerm_subnet.spoke-subnet
}

output "resource_group" {
  value = azurerm_resource_group.spoke-rg
}

output "virtual_network" {
  value = azurerm_virtual_network.spoke-vnet
}
