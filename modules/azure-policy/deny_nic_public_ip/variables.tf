variable "management_group_id" {}

variable "enforce" {
  default = true
  type    = bool
}

variable "not_scopes" {
  default = []
}
