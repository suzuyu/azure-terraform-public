variable "resource_group_name" {}

variable "location" {}

variable "security_group_name" {
  default = "private_ip_all_permit"
}

variable "enable_subnetsid_list" {}
