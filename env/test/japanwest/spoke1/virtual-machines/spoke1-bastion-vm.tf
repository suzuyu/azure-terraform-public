# RG の作成
module "spoke-nsg" {
  source              = "../../../../../modules/spoke/network-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  allow_external_source_address_prefixes = var.spoke_allow_external_source_address_prefixes

  enable_subnetsid_list = [
    var.spoke_vm1_subnet_id
  ]
}

module "spoke-public-windows-vm" {
  source = "../../../../../modules/spoke/public-windows-vm/"

  vm_name             = var.spoke_vm1_name
  size                = var.spoke_vm1_size
  location            = var.location
  resource_group_name = var.resource_group_name
  environment_tags    = ""
  subnet_id           = var.spoke_vm1_subnet_id

  admin_username = var.spoke_vm1_admin_username
  admin_password = var.spoke_vm1_admin_password

  os_disk_type = var.spoke_vm1_os_disk_type
  publisher    = var.spoke_vm1_publisher
  offer        = var.spoke_vm1_offer
  sku          = var.spoke_vm1_sku
}

output "spoke-public-windows-vm-public-ip" {
  value = module.spoke-public-windows-vm.public_ip_address
}
