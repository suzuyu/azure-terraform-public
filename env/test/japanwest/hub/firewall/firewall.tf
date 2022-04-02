# firwall の作成
module "firewall" {
  source              = "../../../../../modules/hub/firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  environment_tags    = var.environment_tags
  subnet_id           = var.subnet_id
  firewall_name       = var.firewall_name
}

output "firewall_private_ip" {
  value = module.firewall.private_ip_address
}

output "firewall_name" {
  value = module.firewall.azure_firewall_name
}
