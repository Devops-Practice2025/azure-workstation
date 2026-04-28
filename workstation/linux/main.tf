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
  default = "southindia"
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
  name                = "ubuntu-gui-vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ubuntu-gui-nsg"
  location            = var.location
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

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
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
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "ubuntu-gui-nic"
  location            = var.location
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
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = "Standard_D2s_v5"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_username = var.admin_username
  admin_password = var.admin_password

  disable_password_authentication = false

  custom_data = base64encode(<<EOF
#
cloud-config
package_update: true

packages:
  - xfce4
  - xfce4-goodies
  - xrdp

runcmd:
  - systemctl enable xrdp
  - echo xfce4-session > /home/${var.admin_username}/.xsession
  - chown ${var.admin_username}:${var.admin_username} /home/${var.admin_username}/.xsession
  - chmod 644 /home/${var.admin_username}/.xsession
  - wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  - sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
    
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
