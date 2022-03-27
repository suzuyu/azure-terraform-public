# RG の作成と VNET と Subnet の管理
module "vnet" {
  source               = "../../../../../modules/hub/vnet/"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = var.virtual_network_name
  address_space        = var.address_space
  subnets              = var.subnets
}

# Peering 向け情報表示
output "virtual_network_name" {
  value = var.virtual_network_name
}

# Peering 向け情報表示
output "virtual_network_id" {
  value = module.vnet.virtual_network_id
}

# 冗長での他リージョンの Hub との Peerirng
module "subregion-peering" {
  source                      = "../../../../../modules/hub/vnet/vnet-peering"
  resource_group_name         = var.resource_group_name
  virtual_network_name        = module.vnet.virtual_network_name
  virtual_network_id          = module.vnet.virtual_network_id
  remote_virtual_network_name = var.subregion_virtual_network_name
  remote_virtual_network_id   = var.subregion_virtual_network_id
}

# ユーザ定義ルート (UDR) 設定
module "udr" {
  source                               = "../../../../../modules/hub/vnet/udr"
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  route_table_name                     = var.route_table_name
  subnets_id_list                      = [module.vnet.subnets["RouterSubnet"].id]
  to_subregion_destination_subnet_list = var.to_subregion_destination_subnet_list
  to_subregion_next_hop_address        = var.to_subregion_next_hop_address
}

# Spoke との Peering
## ./spoke_peering/ に別記載

# Azure Firewall
## ./az-firewall/ に別記載

output "azure-firewall-subnets" {
  value = module.vnet.subnets["AzureFirewallSubnet"].id
}
