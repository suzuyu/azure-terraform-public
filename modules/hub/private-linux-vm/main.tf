resource "azurerm_network_interface" "private-vm-nic" {
  name                 = "nic-01-${var.vm_name}-001"
  location             = var.location
  resource_group_name  = var.resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = (var.private_ip_address == "" ? "Dynamic" : "Static")
    private_ip_address            = var.private_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "private-vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.private-vm-nic.id]
  size                  = var.size
  admin_username        = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }
}

resource "azurerm_virtual_machine_extension" "enableipv4forward" {
  name                 = "ipv4forward"
  virtual_machine_id   = azurerm_linux_virtual_machine.private-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute":"sudo sysctl -w net.ipv4.ip_forward=1"
    }
SETTINGS
}
