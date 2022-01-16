module "spoke-rg" {
  source = "../../../modules/spoke-rg/"

  resource_group   = var.spoke_resource_group
  environment_tags = var.spoke_environment_tags
  location         = var.spoke_location
  vnet_name        = var.spoke_vnet_name
  address_space    = var.spoke_address_space
  subnets = {
    subnet1 = {
      address_prefix = var.spoke_subnet1
    }
  }
}

output "spoke-resource_group_name" {
  value = module.spoke-rg.resource_group.name
}

output "spoke-virtual_network_id" {
  value = module.spoke-rg.virtual_network.id
}

output "spoke-virtual_network_name" {
  value = module.spoke-rg.virtual_network.name
}

module "spoke-route-table" {
  source         = "../../../modules/route-table"
  resource_group = module.spoke-rg.resource_group

  table_name = "route-table"

  enable_subnetsid_list = [
    module.spoke-rg.subnets["subnet1"].id,
  ]

  to_gw_routes_list = concat(
    # module.spoke2-rg.virtual_network.address_space,
    var.azure_all_subnet_range_list,
  )

  depends_on = [
    module.spoke-rg,
  ]
}

module "spoke-nsg" {
  source         = "../../../modules/network-security-group"
  resource_group = module.spoke-rg.resource_group

  allow_external_source_address_prefixes = var.spoke_allow_external_source_address_prefixes

  enable_subnetsid_list = [
    module.spoke-rg.subnets["subnet1"].id,
  ]

  depends_on = [
    module.spoke-rg,
  ]
}

module "spoke-public-linux-vm" {
  source = "../../../modules/public-linux-vm"

  vm_name          = var.spoke_vm1_name
  size             = var.spoke_vm1_size
  resource_group   = module.spoke-rg.resource_group
  environment_tags = var.spoke_environment_tags
  subnet_id        = module.spoke-rg.subnets["subnet1"].id

  admin_username = var.spoke_vm1_admin_username
  admin_ssh_key  = file(var.spoke_vm1_admin_ssh_key_file_path)

  os_disk_type = var.spoke_vm1_os_disk_type
}

output "spoke-public-linux-vm-public-ip" {
  value = module.spoke-public-linux-vm.public_ip_address
}
