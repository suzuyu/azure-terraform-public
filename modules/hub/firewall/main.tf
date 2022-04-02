# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
# https://azure.microsoft.com/ja-jp/pricing/details/ip-addresses/

resource "azurerm_public_ip" "firewall" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  # The Public IP must have a Static allocation and Standard sku.
  allocation_method = "Static"
  sku               = "Standard"
  availability_zone = "No-Zone"
  tags = {
    environment = var.environment_tags
  }
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags = {
    environment = var.environment_tags
  }

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}
