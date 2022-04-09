
module "hub-azure-batsion" {
  source = "../../../../../modules/hub/azure-bastion"

  hostname                        = var.hostname
  location                        = var.location
  resource_group_name             = var.resource_group_name
  subnet_id                       = var.subnet_id
  allow_ingress_public_source_ips = var.allow_ingress_public_source_ips
}
