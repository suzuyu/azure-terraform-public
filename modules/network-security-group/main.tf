# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association

resource "azurerm_network_security_group" "nsg" {
  name                = var.security_group_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_network_security_rule" "external-ingress-rule-1" {
  name                        = "external-ingress-rule-1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389", ]
  source_address_prefixes     = var.allow_external_source_address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "external-ingress-rule-2" {
  name                        = "external-ingress-rule-2"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "ICMP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.allow_external_source_address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "internal-ingress-rule-1" {
  name                        = "internal-ingress-rule-1"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", ]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each                  = toset(var.enable_subnetsid_list)
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
}
