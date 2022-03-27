# RG の作成
module "nsg" {
  source              = "../../../../../modules/hub/network-security-group-private-permit"
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_subnetsid_list = [
    var.router_subnet_id
  ]
}

module "router-linux-vm" {
  source = "../../../../../modules/hub/private-linux-vm"

  vm_name             = var.router_name
  size                = var.router_size
  location            = var.location
  resource_group_name = var.resource_group_name
  environment_tags    = ""
  subnet_id           = var.router_subnet_id
  private_ip_address  = var.router_private_ip_address

  admin_username = var.router_admin_username
  admin_ssh_key  = file(var.router_admin_ssh_key_file_path)

  os_disk_type = var.router_os_disk_type
}
