# Spoke との Peering
module "spoke-peering" {
  source                  = "../../../../../../modules/hub/vnet/spoke-peering"
  resource_group_name     = var.resource_group_name
  virtual_network_name    = var.virtual_network_name
  virtual_network_id      = var.virtual_network_id
  remote_virtual_networks = var.spoke_peering_vnets
}
