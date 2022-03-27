output "virtual_network" {
  value = azurerm_virtual_network.main
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "subnets" {
  value = azurerm_subnet.main
}
