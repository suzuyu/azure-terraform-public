# TEST_RULE の作成
module "test_rules" {
  source              = "../../../../../../modules/hub/firewall/rules"
  name                = "test_rules"
  action              = "Allow"
  priority            = 1000
  resource_group_name = var.resource_group_name
  azure_firewall_name = var.azure_firewall_name
  rules               = var.test_rules
}
