# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment

# # /providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114
# data "azurerm_policy_definition" "deny_nic_public_ip" {
#   display_name = "Network interfaces should not have public IPs"
# }

resource "azurerm_management_group_policy_assignment" "deny_nic_public_ip_assignment" {
  name                 = "deny_nic_public_ip" # length of name to be in the range (3 - 24)
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
}
