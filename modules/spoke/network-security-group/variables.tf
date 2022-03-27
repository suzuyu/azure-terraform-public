variable "resource_group_name" {}

variable "location" {}

variable "security_group_name" {
  default = "default_security_group"
}

variable "allow_external_source_address_prefixes" {}

variable "enable_subnetsid_list" {}
