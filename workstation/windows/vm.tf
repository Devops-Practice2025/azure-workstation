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
  publisher = "MicrosoftWindowsDesktop"
  offer     = "windows-11"
  sku       = "win11-22h2-pro"
  version   = "latest"
}

}
resource "azurerm_virtual_machine_extension" "install_sshd" {

  name                 = "install-openssh"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Bypass -EncodedCommand ${local.sshd_script}"
  })
}

locals {
  sshd_script = textencodebase64(
    file("${path.module}/install-sshd.ps1"),
    "UTF-16LE"
  )
}

