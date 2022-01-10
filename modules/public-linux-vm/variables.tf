variable "resource_group" {}

variable "environment_tags" {}

variable "vm_name" {}

variable "subnet_id" {}

variable "size" {}

variable "os_disk_type" {}

variable "admin_username" {}

variable "admin_ssh_key" {}

variable "publisher" {
  default = "canonical"
}

variable "offer" {
  default = "0001-com-ubuntu-server-focal"
}

variable "sku" {
  default = "20_04-lts-gen2"
}
