variable "resource_group_name" {}

variable "location" {}

variable "environment_tags" {}

variable "vm_name" {}

variable "subnet_id" {}

variable "size" {}

variable "os_disk_type" {}

variable "admin_username" {}

variable "admin_password" {}

variable "publisher" {
  default = "microsoftwindowsdesktop"
  # default = "MicrosoftWindowsServer"
}

variable "offer" {
  default = "windows-11"
  # default = "WindowsServer"
}

variable "sku" {
  default = "win11-21h2-pro"
  # default = "2016-Datacenter"
}

variable "disk_size_gb" {
  default = 128
  # Win11 最小要件：https://www.microsoft.com/ja-jp/windows/windows-11-specifications
  # the size of the corresponding disk in the VM image: 127 GB.
}
