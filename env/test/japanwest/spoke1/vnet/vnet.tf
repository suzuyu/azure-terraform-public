# VNET と Subnet の管理 Hub との接続
module "spoke-vnet" {
  source                      = "../../../../../modules/spoke/vnet/"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  virtual_network_name        = var.virtual_network_name
  address_space               = var.address_space
  subnets                     = var.subnets
  remote_virtual_network_name = var.hub_virtual_network_name
  remote_virtual_network_id   = var.hub_virtual_network_id
  use_remote_gateways         = false
}

output "virtual_network_name" {
  value = var.virtual_network_name
}

output "virtual_network_id" {
  value = module.spoke-vnet.virtual_network_id
}

output "subnets" {
  value = module.spoke-vnet.subnets
}

# ユーザ定義ルート (UDR) 設定
module "udr" {
  source                         = "../../../../../modules/spoke/vnet/udr"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  route_table_name               = var.route_table_name
  subnet_id                      = module.spoke-vnet.subnets["VmSubnet"].id
  to_hub_destination_subnet_list = var.to_hub_destination_subnet_list
  to_hub_next_hop_address        = var.to_hub_next_hop_address
}
