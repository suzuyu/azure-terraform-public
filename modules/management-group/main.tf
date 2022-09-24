# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group
resource "azurerm_management_group" "mg" {
  display_name = var.name
  name         = var.name

  parent_management_group_id = var.parent_management_group_id

  subscription_ids = var.subscription_id_list
}
