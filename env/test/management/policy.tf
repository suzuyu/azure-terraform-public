module "policy-locations" {
  source = "../../../modules/azure-policy/allow_locations/"

  management_group_id    = module.infra-mg.management_group_id
  listOfAllowedLocations = ["japanwest", "japaneast", "japan", ]
}

module "deny-nic-public-ip" {
  source = "../../../modules/azure-policy/deny_nic_public_ip"

  management_group_id = module.infra-mg.management_group_id
}

module "disable_storage_account_public_access" {
  source = "../../../modules/azure-policy/disable_storage_account_public_access"

  management_group_id = module.infra-mg.management_group_id
  effect              = "Deny" # audit, Audit, deny, Deny, disabled, Disabled
}
