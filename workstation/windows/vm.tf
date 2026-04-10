resource "azurerm_windows_virtual_machine" "vm" {
  name                = "testwin2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2_v2"
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}
resource "azurerm_virtual_machine_extension" "chrome" {
  name                 = "install-chrome"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
  "commandToExecute": "powershell -ExecutionPolicy Bypass -Command \"Invoke-WebRequest -Uri https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile C:\\\\chrome.exe; Start-Process C:\\\\chrome.exe -ArgumentList '/silent /install' -Wait\""
}
SETTINGS
}


resource "azurerm_virtual_machine_extension" "install_sshd" {
  name                 = "install-openssh"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \" \
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; \
    Start-Service sshd; \
    Set-Service -Name sshd -StartupType Automatic; \
    New-NetFirewallRule -Name ssh443 -DisplayName 'OpenSSH 443' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 443; \
    \$configPath = 'C:\\ProgramData\\ssh\\sshd_config'; \
    (Get-Content \$configPath) -replace '#Port 22','Port 443' | Set-Content \$configPath; \
    Add-Content \$configPath 'AllowTcpForwarding yes'; \
    Add-Content \$configPath 'GatewayPorts no'; \
    Restart-Service sshd \
  \""
}
SETTINGS
}

