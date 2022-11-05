# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment
# https://learn.microsoft.com/ja-jp/azure/storage/common/policy-reference#microsoftstorage

# # /providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751
# data "azurerm_policy_definition" "disable_storage_account_public_access" {
#   display_name = "[Preview]: Storage account public access should be disallowed"
# }

resource "azurerm_management_group_policy_assignment" "disable_storage_account_public_access" {
  name                = "disable_public_access_st" # length of name to be in the range (3 - 24)
  management_group_id = var.management_group_id

  enforce = var.enforce

  parameters = jsonencode({
    "effect" = {
      "value" = var.effect
    }
  })

  # location = "japaneast"

  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
  # policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/13502221-8df0-4414-9937-de9c5c4e396b"
}
