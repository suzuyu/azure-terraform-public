module "spoke2-rg" {
  source = "../../modules/spoke-rg/"

  resource_group   = var.spoke2_resource_group
  environment_tags = var.spoke2_environment_tags
  location         = var.spoke2_location
  vnet_name        = var.spoke2_vnet_name
  address_space    = var.spoke2_address_space
  subnets = {
    spoke2-subnet1 = {
      address_prefix = var.spoke2_subnet1
    }
  }
}

module "spoke2-route-table" {
  source         = "../../modules/route-table"
  resource_group = module.spoke2-rg.resource_group

  table_name = "spoke2-route-table"

  enable_subnetsid_list = [
    module.spoke2-rg.subnets["spoke2-subnet1"].id,
  ]

  to_gw_routes_list = concat(
    # module.spoke1-rg.virtual_network.address_space,
    var.azure_all_subnet_range_list,
  )
}

module "spoke2-nsg" {
  source         = "../../modules/network-security-group"
  resource_group = module.spoke2-rg.resource_group

  allow_external_source_address_prefixes = var.spoke_allow_external_source_address_prefixes

  enable_subnetsid_list = [
    module.spoke2-rg.subnets["spoke2-subnet1"].id,
  ]
}

module "spoke2-public-windows-vm" {
  source = "../../modules/public-windows-vm/"

  vm_name          = var.spoke2_vm1_name
  size             = var.spoke2_vm1_size
  resource_group   = module.spoke2-rg.resource_group
  environment_tags = var.spoke2_environment_tags
  subnet_id        = module.spoke2-rg.subnets["spoke2-subnet1"].id

  admin_username = var.spoke2_vm1_admin_username
  admin_password = var.spoke2_vm1_admin_password

  os_disk_type = var.spoke2_vm1_os_disk_type
  publisher    = var.spoke2_vm1_publisher
  offer        = var.spoke2_vm1_offer
  sku          = var.spoke2_vm1_sku
}

output "spoke2-public-windows-vm-public-ip" {
  value = module.spoke2-public-windows-vm.public_ip_address
}
