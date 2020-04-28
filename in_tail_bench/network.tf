# Create a virtual network in the production-resources resource group
resource "azurerm_virtual_network" "tailing" {
  name                = "${var.prefix}-tailing-network"
  resource_group_name = azurerm_resource_group.fluentd-tail.name
  location            = azurerm_resource_group.fluentd-tail.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "tail-internal" {
  name                 = "tail-internal"
  resource_group_name  = azurerm_resource_group.fluentd-tail.name
  virtual_network_name = azurerm_virtual_network.tailing.name
  address_prefix       = "10.1.3.0/24"
}

resource "azurerm_public_ip" "linux-aggregator" {
  name                    = "${var.prefix}-aggregator-pip"
  location                = azurerm_resource_group.fluentd-tail.location
  resource_group_name     = azurerm_resource_group.fluentd-tail.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-tail-aggregator-pip"
  }
}

resource "azurerm_network_interface" "linux-aggregator" {
  name                = "${var.prefix}-aggregator-nic"
  location            = azurerm_resource_group.fluentd-tail.location
  resource_group_name = azurerm_resource_group.fluentd-tail.name

  ip_configuration {
    name                          = "tail-aggregator-nic"
    subnet_id                     = azurerm_subnet.tail-internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.3.4"
    public_ip_address_id          = azurerm_public_ip.linux-aggregator.id
  }
}

resource "azurerm_public_ip" "linux-collector" {
  name                    = "${var.prefix}-collector-pip"
  location                = azurerm_resource_group.fluentd-tail.location
  resource_group_name     = azurerm_resource_group.fluentd-tail.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-collector-pip"
  }
}

resource "azurerm_network_interface" "linux-collector" {
  name                = "${var.prefix}-collector-nic"
  location            = azurerm_resource_group.fluentd-tail.location
  resource_group_name = azurerm_resource_group.fluentd-tail.name

  ip_configuration {
    name                          = "collector-nic"
    subnet_id                     = azurerm_subnet.tail-internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.3.5"
    public_ip_address_id          = azurerm_public_ip.linux-collector.id
  }
}
