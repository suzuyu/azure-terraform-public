# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  alias                      = "hub"
  tenant_id                  = var.hub_tenant_id
  subscription_id            = var.hub_subscription_id
  skip_provider_registration = true
  auxiliary_tenant_ids       = [var.spoke_tenant_id, ]
  features {}
  # client_id                  = var.client_id     # ARM_CLIENT_ID
  # client_secret              = var.client_secret # ARM_CLIENT_SECRET
}

provider "azurerm" {
  alias                      = "spoke"
  tenant_id                  = var.spoke_tenant_id
  subscription_id            = var.spoke_subscription_id
  skip_provider_registration = true
  auxiliary_tenant_ids       = [var.hub_tenant_id, ]
  features {}
  # client_id                  = var.client_id     # ARM_CLIENT_ID
  # client_secret              = var.client_secret # ARM_CLIENT_SECRET
}

# https://registry.terraform.io/providers/hashicorp/azurerm/3.1.0/docs/data-sources/virtual_network
data "azurerm_virtual_network" "hub" {
  name                = var.hub_virtual_network_name
  resource_group_name = var.hub_resource_group_name
  provider            = azurerm.hub
}

data "azurerm_virtual_network" "spoke" {
  name                = var.spoke_virtual_network_name
  resource_group_name = var.spoke_resource_group_name
  provider            = azurerm.spoke
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "peer-${data.azurerm_virtual_network.hub.name}-to-${data.azurerm_virtual_network.spoke.name}"
  resource_group_name          = data.azurerm_virtual_network.hub.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.hub.name
  remote_virtual_network_id    = data.azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  provider                     = azurerm.hub
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "peer-${data.azurerm_virtual_network.spoke.name}-to-${data.azurerm_virtual_network.hub.name}"
  resource_group_name          = data.azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = data.azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  provider                     = azurerm.spoke
}
