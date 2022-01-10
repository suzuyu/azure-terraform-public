resource "azurerm_public_ip" "public-vm-pip" {
  name                = "${var.vm_name}-pip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment_tags
  }
}

resource "azurerm_network_interface" "public-vm-nic" {
  name                 = "${var.vm_name}-nic"
  location             = var.resource_group.location
  resource_group_name  = var.resource_group.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-vm-pip.id
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine
resource "azurerm_windows_virtual_machine" "public-vm" {
  name                  = var.vm_name
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.public-vm-nic.id]
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = "latest"
  }
}
