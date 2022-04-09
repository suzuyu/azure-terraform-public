variable "resource_group_name" {}

variable "location" {}

variable "hostname" {}

variable "subnet_id" {} # https://docs.microsoft.com/ja-jp/azure/bastion/configuration-settings#subnet /26 以上

# https://docs.microsoft.com/ja-jp/azure/bastion/configuration-settings#skus
##  Basic -> Standard 可能 https://docs.microsoft.com/ja-jp/azure/bastion/upgrade-sku
variable "sku" {
  type    = string
  default = "Basic" # Basic or Standard
}

# azurerm version 2.93.0 以上が必須
variable "copy_paste_enabled" {
  type    = bool
  default = true
}

# azurerm version 2.93.0 以上が必須
# sku = "Standard" が必須
variable "file_copy_enabled" {
  type    = bool
  default = true
}

# azurerm version 2.93.0 以上が必須
# sku = "Standard" が必須
variable "scale_units" {
  type    = number
  default = 2
}

variable "allow_ingress_public_source_ips" {
  type    = list(string)
  default = null
}
