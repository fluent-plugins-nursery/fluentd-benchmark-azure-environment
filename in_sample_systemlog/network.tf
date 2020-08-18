# Create a virtual network in the production-resources resource group
resource "azurerm_virtual_network" "systemlog" {
  name                = "${var.prefix}-systemlog-network"
  resource_group_name = azurerm_resource_group.fluentd-systemlog.name
  location            = azurerm_resource_group.fluentd-systemlog.location
  address_space       = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "systemlog-internal" {
  name                 = "systemlog-internal"
  resource_group_name  = azurerm_resource_group.fluentd-systemlog.name
  virtual_network_name = azurerm_virtual_network.systemlog.name
  address_prefixes     = ["10.3.3.0/24"]
}

resource "azurerm_public_ip" "linux-collector" {
  name                    = "${var.prefix}-collector-pip"
  location                = azurerm_resource_group.fluentd-systemlog.location
  resource_group_name     = azurerm_resource_group.fluentd-systemlog.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-collector-pip"
  }
}

resource "azurerm_network_interface" "linux-collector" {
  name                = "${var.prefix}-collector-nic"
  location            = azurerm_resource_group.fluentd-systemlog.location
  resource_group_name = azurerm_resource_group.fluentd-systemlog.name

  ip_configuration {
    name                          = "collector-nic"
    subnet_id                     = azurerm_subnet.systemlog-internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.3.3.5"
    public_ip_address_id          = azurerm_public_ip.linux-collector.id
  }
}
