output "publie_ip_address" {
  value = azurerm_public_ip.firewall.ip_address
}

output "private_ip_address" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "azure_firewall_name" {
  value = azurerm_firewall.firewall.name
}
