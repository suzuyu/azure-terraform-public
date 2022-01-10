module "spoke1-rg" {
  source = "../../modules/spoke-rg/"

  resource_group   = var.spoke1_resource_group
  environment_tags = var.spoke1_environment_tags
  location         = var.spoke1_location
  vnet_name        = var.spoke1_vnet_name
  address_space    = var.spoke1_address_space
  subnets = {
    spoke1-subnet1 = {
      address_prefix = var.spoke1_subnet1
    }
  }
}

module "spoke1-route-table" {
  source         = "../../modules/route-table"
  resource_group = module.spoke1-rg.resource_group

  table_name = "spoke1-route-table"

  enable_subnetsid_list = [
    module.spoke1-rg.subnets["spoke1-subnet1"].id,
  ]

  to_gw_routes_list = concat(
    module.spoke2-rg.virtual_network.address_space,
  )
}

module "spoke1-nsg" {
  source         = "../../modules/network-security-group"
  resource_group = module.spoke1-rg.resource_group

  allow_external_source_address_prefixes = var.spoke_allow_external_source_address_prefixes

  enable_subnetsid_list = [
    module.spoke1-rg.subnets["spoke1-subnet1"].id,
  ]
}

module "spoke1-public-linux-vm" {
  source = "../../modules/public-linux-vm"

  vm_name          = var.spoke1_vm1_name
  size             = var.spoke1_vm1_size
  resource_group   = module.spoke1-rg.resource_group
  environment_tags = var.spoke1_environment_tags
  subnet_id        = module.spoke1-rg.subnets["spoke1-subnet1"].id

  admin_username = var.spoke1_vm1_admin_username
  admin_ssh_key  = file(var.spoke1_vm1_admin_ssh_key_file_path)

  os_disk_type = var.spoke1_vm1_os_disk_type
}

output "spoke1-public-linux-vm-public-ip" {
  value = module.spoke1-public-linux-vm.public_ip_address
}
