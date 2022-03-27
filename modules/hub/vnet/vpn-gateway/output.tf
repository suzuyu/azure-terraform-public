output "vpn-ip-address" {
  value = azurerm_public_ip.vpn-gateway-pip.ip_address
}
