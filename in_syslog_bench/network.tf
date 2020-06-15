# Create a virtual network in the production-resources resource group
resource "azurerm_virtual_network" "syslog" {
  name                = "${var.prefix}-syslog-network"
  resource_group_name = azurerm_resource_group.fluentd-syslog.name
  location            = azurerm_resource_group.fluentd-syslog.location
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "syslog-internal" {
  name                 = "syslog-internal"
  resource_group_name  = azurerm_resource_group.fluentd-syslog.name
  virtual_network_name = azurerm_virtual_network.syslog.name
  address_prefixes     = ["10.2.3.0/24"]
}

resource "azurerm_public_ip" "linux-aggregator" {
  name                    = "${var.prefix}-aggregator-pip"
  location                = azurerm_resource_group.fluentd-syslog.location
  resource_group_name     = azurerm_resource_group.fluentd-syslog.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-syslog-aggregator-pip"
  }
}

resource "azurerm_network_interface" "linux-aggregator" {
  name                = "${var.prefix}-aggregator-nic"
  location            = azurerm_resource_group.fluentd-syslog.location
  resource_group_name = azurerm_resource_group.fluentd-syslog.name

  ip_configuration {
    name                          = "syslog-aggregator-nic"
    subnet_id                     = azurerm_subnet.syslog-internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.3.4"
    public_ip_address_id          = azurerm_public_ip.linux-aggregator.id
  }
}

resource "azurerm_public_ip" "linux-collector" {
  name                    = "${var.prefix}-collector-pip"
  location                = azurerm_resource_group.fluentd-syslog.location
  resource_group_name     = azurerm_resource_group.fluentd-syslog.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-collector-pip"
  }
}

resource "azurerm_network_interface" "linux-collector" {
  name                = "${var.prefix}-collector-nic"
  location            = azurerm_resource_group.fluentd-syslog.location
  resource_group_name = azurerm_resource_group.fluentd-syslog.name

  ip_configuration {
    name                          = "collector-nic"
    subnet_id                     = azurerm_subnet.syslog-internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.3.5"
    public_ip_address_id          = azurerm_public_ip.linux-collector.id
  }
}
