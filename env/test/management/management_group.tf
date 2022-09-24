module "infra-mg" {
  source = "../../../modules/management-group/"

  name                       = "infra-mg"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/${var.Tenant_Root_Group_id}"

  subscription_id_list = [
    var.subscription_id,
  ]
}

output "test" {
  value = module.infra-mg.management_group_id
}
