resource "azurerm_network_security_group" "collector" {
  name                = "BenchmarkSecurityGroup"
  location            = var.region
  resource_group_name = azurerm_resource_group.fluentd.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WinRM"
    priority                   = 998
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WinRM-out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Creating with Terraform"
  }
}

# Create a virtual network in the production-resources resource group
resource "azurerm_virtual_network" "fluentd" {
  name                = "${var.prefix}-network"
  resource_group_name = azurerm_resource_group.fluentd.name
  location            = azurerm_resource_group.fluentd.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.fluentd.name
  virtual_network_name = azurerm_virtual_network.fluentd.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "aggregator" {
  name                    = "${var.prefix}-aggregator-pip"
  location                = azurerm_resource_group.fluentd.location
  resource_group_name     = azurerm_resource_group.fluentd.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-aggregator-pip"
  }
}

resource "azurerm_network_interface" "aggregator" {
  name                = "${var.prefix}-aggregator-nic"
  location            = azurerm_resource_group.fluentd.location
  resource_group_name = azurerm_resource_group.fluentd.name

  ip_configuration {
    name                          = "aggregator-nic"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.4"
    public_ip_address_id          = azurerm_public_ip.aggregator.id
  }
}

resource "azurerm_public_ip" "collector" {
  name                    = "${var.prefix}-collector-pip"
  location                = azurerm_resource_group.fluentd.location
  resource_group_name     = azurerm_resource_group.fluentd.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "${var.prefix}-collector-pip"
  }
}

resource "azurerm_network_interface" "collector" {
  name                = "${var.prefix}-collector-nic"
  location            = azurerm_resource_group.fluentd.location
  resource_group_name = azurerm_resource_group.fluentd.name

  ip_configuration {
    name                          = "collector-nic"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.collector.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "collector" {
  network_interface_id      = azurerm_network_interface.collector.id
  network_security_group_id = azurerm_network_security_group.collector.id
}
