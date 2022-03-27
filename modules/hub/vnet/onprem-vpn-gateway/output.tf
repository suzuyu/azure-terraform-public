output "onprem-vpn-azure-public-ip-address" {
  value = azurerm_public_ip.main.ip_address
}

output "azure-bgp-router-ip" {
  value = azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]
}

# Example Config Parameters
locals {
  onprem_subnet             = "192.168.129.0/24"
  onprem_vpn_private_eth_ip = "192.168.10.99"
  onprem_ipsec_interface    = "vti2"
}

output "onprem-edgerouterx-example-config" {
  value = join("\n", [
    "set interfaces vti ${local.onprem_ipsec_interface} mtu 1291",
    "set policy prefix-list azure-export rule 100 action permit",
    "set policy prefix-list azure-export rule 100 le 32",
    "set policy prefix-list azure-export rule 100 prefix ${local.onprem_subnet}",
    "set policy route-map TO-Azure-OUT-1 rule 1 action permit",
    "set policy route-map TO-Azure-OUT-1 rule 1 match ip address prefix-list azure-export",
    "set policy route-map TO-Azure-OUT-1 rule 1 set metric 100",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} ebgp-multihop 2",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} prefix-list",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} remote-as ${var.onprem_asn}",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} route-map export TO-Azure-OUT-1",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} soft-reconfiguration inbound",
    "set protocols bgp ${var.onprem_asn} neighbor ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]} update-source ${var.onprem_bgp_neighbor_addr}",
    "set protocols bgp ${var.onprem_asn} network ${var.onprem_bgp_neighbor_addr}/32",
    "set protocols bgp ${var.onprem_asn} parameters graceful-restart stalepath-time 300",
    "set protocols bgp ${var.onprem_asn} parameters router-id ${var.onprem_bgp_neighbor_addr}",
    "set protocols bgp ${var.onprem_asn} timers holdtime ",
    "set protocols bgp ${var.onprem_asn} timers keepalive 60",
    "set protocols static interface-route ${azurerm_virtual_network_gateway.main.bgp_settings[0].peering_addresses[0].default_addresses[0]}/32 next-hop-interface ${local.onprem_ipsec_interface}",
    "set vpn ipsec allow-access-to-local-interface disable",
    "set vpn ipsec auto-firewall-nat-exclude enable",
    "set vpn ipsec esp-group azure-esp compression disable",
    "set vpn ipsec esp-group azure-esp lifetime 3600",
    "set vpn ipsec esp-group azure-esp mode tunnel",
    "set vpn ipsec esp-group azure-esp pfs disable",
    "set vpn ipsec esp-group azure-esp proposal 1 encryption aes256",
    "set vpn ipsec esp-group azure-esp proposal 1 hash sha1",
    "set vpn ipsec ike-group azure-ike dead-peer-detection action restart",
    "set vpn ipsec ike-group azure-ike dead-peer-detection interval 30",
    "set vpn ipsec ike-group azure-ike dead-peer-detection timeout 120",
    "set vpn ipsec ike-group azure-ike ikev2-reauth no",
    "set vpn ipsec ike-group azure-ike key-exchange ikev2",
    "set vpn ipsec ike-group azure-ike lifetime 3600",
    "set vpn ipsec ike-group azure-ike proposal 1 dh-group 2",
    "set vpn ipsec ike-group azure-ike proposal 1 encryption aes256",
    "set vpn ipsec ike-group azure-ike proposal 1 hash sha1",
    "set vpn ipsec ipsec-interfaces interface ${local.onprem_ipsec_interface}",
    "set vpn ipsec nat-traversal enable",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} authentication id ${var.onprem_public_ip}",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} authentication mode pre-shared-secret",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} authentication pre-shared-secret ${var.shared_key}",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} connection-type initiate",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} description IPsecAzure",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} ike-group azure-ike",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} ikev2-reauth inherit",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} local-address ${local.onprem_vpn_private_eth_ip}",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} vti bind ${local.onprem_ipsec_interface}",
    "set vpn ipsec site-to-site peer ${azurerm_public_ip.main.ip_address} vti esp-group azure-esp",
  ])
}
