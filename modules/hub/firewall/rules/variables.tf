variable "resource_group_name" {}

variable "azure_firewall_name" {}

variable "name" {}

variable "priority" {
  default = 1000
}

variable "action" {}

variable "rules" {
  # # SAMPLE
  # default = [
  #   {
  #     name                  = "172_to_172_ICMP_permit"
  #     priority              = 1000
  #     action                = "Allow"
  #     source_addresses      = ["172.16.0.0/12", ]
  #     destination_addresses = ["172.16.0.0/12", ]
  #     protocols             = ["ICMP"]
  #     destination_ports     = ["*"]
  #   },
  #   {
  #     name                  = "172_to_172_and_192_permit"
  #     priority              = 1010
  #     action                = "Allow"
  #     source_addresses      = ["172.16.0.0/12", ]
  #     destination_addresses = ["172.16.0.0/12", "192.168.0.0/16", ]
  #     protocols             = ["TCP"]
  #     destination_ports     = ["22"]
  #   },
  # ]
}
