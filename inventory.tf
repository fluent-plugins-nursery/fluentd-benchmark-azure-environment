data "azurerm_public_ip" "collector" {
  name                = azurerm_public_ip.collector.name
  resource_group_name = azurerm_virtual_machine.win10collector.resource_group_name
}

output "collector_public_ip_address" {
  value = data.azurerm_public_ip.collector.ip_address
}

data "azurerm_public_ip" "aggregator" {
  name                = azurerm_public_ip.aggregator.name
  resource_group_name = azurerm_virtual_machine.aggregator.resource_group_name
}

output "aggregator_public_ip_address" {
  value = data.azurerm_public_ip.aggregator.ip_address
}

resource "local_file" "inventory" {
  filename = "ansible/hosts"
  content  = <<EOL
[windows]
${data.azurerm_public_ip.collector.ip_address}

[windows:vars]
ansible_user=${var.windows-username}
ansible_password=${var.windows-password}
ansible_port=5986
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore

[aggregator]
${data.azurerm_public_ip.aggregator.ip_address}
EOL
}
