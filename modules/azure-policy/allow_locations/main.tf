# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment

# # /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c
# data "azurerm_policy_definition" "allowed_locations" {
#   display_name = "Allowed locations"
# }

resource "azurerm_management_group_policy_assignment" "allowed_locations_assignment" {
  name                 = "location-policy" # length of name to be in the range (3 - 24)
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c" # data.azurerm_policy_definition.allowed_locations.id
  parameters = jsonencode({
    "listOfAllowedLocations" = {
      "value" = var.listOfAllowedLocations
    }
  })
}
