variable "management_group_id" {}

variable "listOfAllowedLocations" {
  type    = list(string)
  default = ["japanwest", "japaneast", "japan", ]
}
