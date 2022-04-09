# NSG / https://docs.microsoft.com/ja-jp/azure/bastion/bastion-nsg#apply
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-azurebastion-001"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# パブリック インターネットからのイグレス トラフィック: Azure Bastion によってパブリック IP が作成されます。このパブリック IP では、イグレス トラフィック用にポート 443 が有効になっている必要があります。 AzureBastionSubnet でポート 3389/22 が開かれている必要はありません。 ソースは、インターネット、または指定したパブリック IP アドレスのセットのいずれかであることに注意してください。
resource "azurerm_network_security_rule" "ingress-rule-1" {
  name                        = "AllowHttpsInbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", ]
  source_address_prefix       = var.allow_ingress_public_source_ips == null ? "Internet" : null
  source_address_prefixes     = var.allow_ingress_public_source_ips == null ? null : var.allow_ingress_public_source_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Azure Bastion からのイグレス トラフィックのコントロール プレーン: コントロール プレーン接続の場合は、GatewayManager サービス タグからのポート 443 受信を有効にします。 これにより、コントロール プレーン、つまりゲートウェイ マネージャーから Azure Bastion への通信が可能になります。
resource "azurerm_network_security_rule" "ingress-rule-2" {
  name                        = "AllowGatewayManagerInbound"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", ]
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Azure Load Balancer からのイングレス トラフィック: 正常性プローブの場合は、AzureLoadBalancer サービス タグからのポート 443 受信を有効にします。 これにより、Azure Load Balancer は接続を検出できます
resource "azurerm_network_security_rule" "ingress-rule-3" {
  name                        = "AllowAzureLoadBalancerInbound"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", ]
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Azure Bastion データ プレーンからのイングレス トラフィック: Azure Bastion の基盤コンポーネント間でのデータ プレーン通信については、ポート 8080, 5701 で、VirtualNetwork サービス タグから VirtualNetwork サービス タグへの受信を有効にします。 これにより、Azure Bastion のコンポーネントが相互に通信できるようになります。
resource "azurerm_network_security_rule" "ingress-rule-4" {
  name                        = "AllowBastionHostCommunicationInbound"
  priority                    = 1030
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701", ]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}


resource "azurerm_network_security_rule" "ingress-rule-deny" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# ターゲット VM へのエグレス トラフィック: Azure Bastion は、プライベート IP 経由でターゲット VM にリーチします。 NSG では、他のターゲット VM サブネットへのエグレス トラフィックをポート 3389 と 22 に許可する必要があります。 Standard SKU の一部としてカスタム ポート機能を使用している場合、NSG では代わりに、他のターゲット VM サブネットへのエグレス トラフィックを、ターゲット VM で開いたカスタム値に許可する必要があります。
resource "azurerm_network_security_rule" "egress-rule-1" {
  name                        = "AllowSshRdpOutbound"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "3389", ]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Azure の他のパブリックエンド ポイントへのエグレス トラフィック: Azure Bastion から Azure 内のさまざまなパブリック エンドポイントに接続できる必要があります (たとえば、診断ログや測定ログを格納するため)。 このため、Azure Bastion には AzureCloud サービス タグに対する 443 への送信が必要です。
resource "azurerm_network_security_rule" "egress-rule-2" {
  name                        = "AllowAzureCloudOutbound"
  priority                    = 1010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443", ]
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Azure Bastion データ プレーンへのエグレス トラフィック: Azure Bastion の基盤コンポーネント間でのデータ プレーン通信については、ポート 8080, 5701 で、VirtualNetwork サービス タグから VirtualNetwork サービス タグへの送信を有効にします。 これにより、Azure Bastion のコンポーネントが相互に通信できるようになります。
resource "azurerm_network_security_rule" "egress-rule-3" {
  name                        = "AllowBastionHostCommunicationOutbound"
  priority                    = 1020
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "5701", ]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# インターネットへのエグレス トラフィック: Azure Bastion は、セッションと証明書の検証のためにインターネットと通信できる必要があります。 そのため、ポート 80 でインターネットへの送信を有効にすることをお勧めします。
resource "azurerm_network_security_rule" "egress-rule-4" {
  name                        = "AllowGetSessionInfomation"
  priority                    = 1030
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["80", ]
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "egress-rule-deny" {
  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [
    azurerm_network_security_rule.ingress-rule-1,
    azurerm_network_security_rule.ingress-rule-2,
    azurerm_network_security_rule.ingress-rule-3,
    azurerm_network_security_rule.ingress-rule-4,
    azurerm_network_security_rule.ingress-rule-deny,
    azurerm_network_security_rule.egress-rule-1,
    azurerm_network_security_rule.egress-rule-2,
    azurerm_network_security_rule.egress-rule-3,
    azurerm_network_security_rule.egress-rule-4,
    azurerm_network_security_rule.egress-rule-deny,
  ]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host
resource "azurerm_public_ip" "main" {
  name                = "pip-bas-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = var.hostname
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  copy_paste_enabled  = var.copy_paste_enabled
  file_copy_enabled   = var.sku == "Basic" ? null : var.file_copy_enabled
  scale_units         = var.sku == "Basic" ? null : var.scale_units

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.main.id
  }
  depends_on = [
    azurerm_subnet_network_security_group_association.nsg,
  ]
}
