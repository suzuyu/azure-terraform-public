variable "resource_group_name" {}

variable "location" {}

variable "security_group_name" {
  default = "nsg-default-001"
}

variable "allow_external_source_address_prefixes" {}

variable "enable_subnetsid_list" {}
