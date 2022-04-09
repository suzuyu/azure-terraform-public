variable "resource_group_name" {}

variable "location" {}

variable "hostname" {}

variable "subnet_id" {}

variable "allow_ingress_public_source_ips" {
  type    = list(string)
  default = null
}
