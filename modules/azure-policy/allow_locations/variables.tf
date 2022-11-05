variable "management_group_id" {}

variable "listOfAllowedLocations" {
  type    = list(string)
  default = ["japanwest", "japaneast", "japan", ]
}

variable "enforce" {
  default = true
  type    = bool
}

variable "not_scopes" {
  default = []
}
