# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection

resource "azurerm_firewall_network_rule_collection" "main" {
  name                = var.name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.action

  dynamic "rule" {
    for_each = var.rules
    content {
      name                  = rule.value.name
      description           = lookup(rule.value, "description", null)
      source_addresses      = lookup(rule.value, "source_addresses", null)
      source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
      destination_addresses = lookup(rule.value, "destination_addresses", null)
      destination_ip_groups = lookup(rule.value, "destination_ip_groups", null)
      destination_ports     = lookup(rule.value, "destination_ports", null)
      protocols             = lookup(rule.value, "protocols", null)
    }
  }
}
