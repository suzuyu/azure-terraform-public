output "onprem-vpn-ip-address" {
    value = azurerm_public_ip.onprem-vpn-gateway-pip.ip_address
}
