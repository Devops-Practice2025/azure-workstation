terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

############################
# VARIABLES
############################

variable "location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "testrg1"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  description = "VM login password for RDP"
   # CHANGE THIS
}

############################
# RESOURCE GROUP
############################

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  
}

############################
# NETWORKING
############################

resource "azurerm_virtual_network" "vnet" {
  name                = "ubuntu-gui-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ubuntu-gui-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
  name                = "ubuntu-gui-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "ubuntu-gui-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

############################
# UBUNTU VM WITH GUI
############################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "ubuntu-gui-vm"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_B2s"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  custom_data = base64encode(<<EOF
#cloud-config
package_update: true
package_upgrade: true

packages:
  - ubuntu-desktop-minimal
  - xrdp

runcmd:
  - systemctl enable xrdp
  - systemctl restart xrdp
  - adduser xrdp ssl-cert
  - echo "exec gnome-session" > /home/${var.admin_username}/.xsession
  - chown ${var.admin_username}:${var.admin_username} /home/${var.admin_username}/.xsession
EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
