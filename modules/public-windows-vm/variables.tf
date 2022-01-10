variable "resource_group" {}

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
