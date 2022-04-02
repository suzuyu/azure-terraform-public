variable "resource_group_name" {}

variable "location" {}

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

variable "image_version" {
  default = "latest"
}

variable "private_ip_address" {
  type    = string
  default = ""
}

variable "disk_size_gb" {
  default = 30
  # Disk: a minimum of 2.5 gigabytes https://ubuntu.com/server/docs/installation
  # the size of the corresponding disk in the VM image: 30 GB.
}
