# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
# https://azure.microsoft.com/ja-jp/pricing/details/ip-addresses/

resource "azurerm_public_ip" "vpn-gateway-pip" {
  name                = "${var.vpn_name}-gateway-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  # allocation_method   = "Static"
  # sku                 = "Basic"
  allocation_method = "Dynamic"
}

output "azurerm_public_ip_vpn-gateway-pip" {
  value = azurerm_public_ip.vpn-gateway-pip.ip_address
}

resource "azurerm_virtual_network_gateway" "vpn-gateway" {
  name                = "${var.vpn_name}-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = var.enable_bgp
  sku           = var.vpn_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn-gateway-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  depends_on = [azurerm_public_ip.vpn-gateway-pip]
}
