variable "resource_group_name" {}

variable "location" {}

variable "security_group_name" {
  default = "nsg-default-001"
}

variable "enable_subnetsid_list" {}
