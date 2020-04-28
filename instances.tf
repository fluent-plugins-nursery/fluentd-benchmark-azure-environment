resource "azurerm_virtual_machine" "aggregator" {
  name                  = "${var.prefix}-aggregator-vm"
  location              = azurerm_resource_group.fluentd.location
  resource_group_name   = azurerm_resource_group.fluentd.name
  network_interface_ids = [azurerm_network_interface.aggregator.id]
  vm_size               = "Standard_B2S"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "aggregator-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-ubuntu"
    admin_username = var.linux-username
    admin_password = var.linux-password
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.linux-username}/.ssh/authorized_keys"
      key_data = file("azure_key/id_rsa_azure.pub")
    }
  }
  tags = {
    environment = "benchmarking"
  }
}

resource "azurerm_virtual_machine" "win10collector" {
  name                             = "${var.prefix}-collector-win10-vm"
  location                         = azurerm_resource_group.fluentd.location
  resource_group_name              = azurerm_resource_group.fluentd.name
  network_interface_ids            = [azurerm_network_interface.collector.id]
  vm_size                          = "Standard_B2S"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "19h1-pro"
    version   = "latest"
  }

  storage_os_disk {
    name              = "win10-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    os_type           = "Windows"
  }

  os_profile {
    computer_name  = "${var.prefix}-windows"
    admin_username = var.windows-username
    admin_password = var.windows-password
    custom_data    = file("./config/settings.ps1")
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
    winrm {
      protocol = "http"
    }
    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.windows-password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.windows-username}</Username></AutoLogon>"
    }
    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file("./config/FirstLogonCommands.xml")
    }
  }

  tags = {
    CreatedBy = var.windows-username
    Purpose   = "Collect Windows EventLog Benchmark"
  }

  connection {
    host     = azurerm_public_ip.collector.ip_address
    type     = "winrm"
    port     = 5985
    https    = false
    timeout  = "2m"
    user     = var.windows-username
    password = var.windows-password
  }
}
