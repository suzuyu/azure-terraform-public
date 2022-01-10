# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
# https://azure.microsoft.com/ja-jp/pricing/details/ip-addresses/

resource "azurerm_public_ip" "onprem-vpn-gateway-pip" {
    name                = "${var.vpn_name}-gateway-pip"
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name
    # allocation_method   = "Static"
    # sku                 = "Basic"
    allocation_method = "Dynamic"
    tags = {
      environment = var.environment_tags
    }
}

output "azurerm_public_ip_onprem-vpn-gateway-pip" {
  value = azurerm_public_ip.onprem-vpn-gateway-pip.ip_address
}

resource "azurerm_virtual_network_gateway" "onprem-vpn-gateway" {
    name                = "${var.vpn_name}-gateway"
    location            = var.resource_group.location
    resource_group_name = var.resource_group.name

    type     = "Vpn"
    vpn_type = "RouteBased"

    active_active = false
    enable_bgp    = true
    sku           = "VpnGw1"

    ip_configuration {
        name                          = "vnetGatewayConfig"
        public_ip_address_id          = azurerm_public_ip.onprem-vpn-gateway-pip.id
        private_ip_address_allocation = "Dynamic"
        subnet_id                     = var.subnet_id
    }

    bgp_settings {
      asn = var.bgp_asn
    }

    tags = {
      environment = var.environment_tags
    }

    depends_on = [azurerm_public_ip.onprem-vpn-gateway-pip]
}

# ローカル(オンプレミス)側情報
resource "azurerm_local_network_gateway" "onpremise" {
  name                = "${var.vpn_name}-local-network-gateway"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  gateway_address     = var.onprem_public_ip
  # gateway_fqdn        = var.onprem_public_fqdn
  address_space       = var.onprem_network_subnets_list

  bgp_settings {
    asn                 = var.onprem_asn
    peer_weight         = 0
    bgp_peering_address = var.onprem_bgp_neighbor_addr
  }

  tags = {
    environment = var.environment_tags
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection
resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = "${var.vpn_name}-connection"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpn-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremise.id

  enable_bgp = true

  shared_key = var.shared_key

  tags = {
    environment = var.environment_tags
  }
}
