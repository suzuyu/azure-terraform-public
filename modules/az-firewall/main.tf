# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall
# https://azure.microsoft.com/ja-jp/pricing/details/ip-addresses/

resource "azurerm_public_ip" "firewall" {
  name                = "${var.firewall_name}-public-ip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  # The Public IP must have a Static allocation and Standard sku.
  allocation_method = "Static"
  sku               = "Standard"
  tags = {
    environment = var.environment_tags
  }
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags = {
    environment = var.environment_tags
  }

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  # management_ip_configuration {
  #   name                 = "configuration"
  #   subnet_id            = var.subnet_id
  #   public_ip_address_id = azurerm_public_ip.firewall.id
  # }
}
