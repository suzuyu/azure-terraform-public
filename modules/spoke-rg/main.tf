resource "azurerm_resource_group" "spoke-rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_virtual_network" "spoke-vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.spoke-rg.location
  resource_group_name = azurerm_resource_group.spoke-rg.name
  address_space       = var.address_space
  tags = {
    environment = var.environment_tags
  }
}

resource "azurerm_subnet" "spoke-subnet" {
    for_each             = var.subnets
    name                 = each.key
    resource_group_name  = azurerm_resource_group.spoke-rg.name
    virtual_network_name = azurerm_virtual_network.spoke-vnet.name
    address_prefixes     = [each.value.address_prefix]
}
