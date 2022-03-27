# RG の作成
module "hub" {
  source              = "../../../../modules/spoke/"
  resource_group_name = var.resource_group_name
  location            = var.location
}
