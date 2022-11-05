variable "management_group_id" {}

variable "enforce" {
  default = true
  type    = bool
}

variable "not_scopes" {
  default = []
}

variable "effect" {
  # audit; Audit; deny; Deny; disabled; Disabled
  default = "Audit"
  type    = string
}
