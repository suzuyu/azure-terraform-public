# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
# https://azure.microsoft.com/ja-jp/pricing/details/ip-addresses/

resource "azurerm_public_ip" "main" {
  name                = "pip-${var.vpn_name}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  # allocation_method   = "Static"
  # sku                 = "Basic"
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "vgw-${var.vpn_name}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = var.vpn_sku #"VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.main.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  bgp_settings {
    asn = var.bgp_asn
  }

  depends_on = [azurerm_public_ip.main]
}

# ローカル(オンプレミス)側情報
resource "azurerm_local_network_gateway" "main" {
  name                = "lgw-${var.vpn_name}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.onprem_public_ip
  # gateway_fqdn        = var.onprem_public_fqdn
  address_space = var.onprem_network_subnets_list

  bgp_settings {
    asn                 = var.onprem_asn
    peer_weight         = 0
    bgp_peering_address = var.onprem_bgp_neighbor_addr
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
resource "azurerm_virtual_network_gateway_connection" "main" {
  name                = "con-${azurerm_virtual_network_gateway.main.name}-${azurerm_local_network_gateway.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main.id

  enable_bgp = true

  shared_key = var.shared_key
}
