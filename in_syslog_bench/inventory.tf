data "azurerm_public_ip" "linux-collector" {
  name                = azurerm_public_ip.linux-collector.name
  resource_group_name = azurerm_virtual_machine.linux-collector.resource_group_name
}

output "collector_public_ip_address" {
  value = data.azurerm_public_ip.linux-collector.ip_address
}

data "azurerm_public_ip" "linux-aggregator" {
  name                = azurerm_public_ip.linux-aggregator.name
  resource_group_name = azurerm_virtual_machine.linux-aggregator.resource_group_name
}

output "aggregator_public_ip_address" {
  value = data.azurerm_public_ip.linux-aggregator.ip_address
}

resource "local_file" "inventory" {
  filename        = "ansible/hosts"
  file_permission = "0644"
  content         = <<EOL
[collector]
${data.azurerm_public_ip.linux-collector.ip_address}

[collector:vars]
ansible_port=22
ansible_user=${var.collector-username}
ansible_ssh_private_key_file=${var.ssh-private-key-path}

[aggregator]
${data.azurerm_public_ip.linux-aggregator.ip_address}

[aggregator:vars]
ansible_port=22
ansible_user=${var.aggregator-username}
ansible_ssh_private_key_file=${var.ssh-private-key-path}
EOL
}
