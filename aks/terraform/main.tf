# --- Resource Group (use existing or create) ---
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

# --- SSH key pair (private key can be output-securely or written to a secure file in pipeline) ---
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# --- AKS Cluster ---
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${var.cluster_name}-dns"

  kubernetes_version  = null # Optional: pin a version like "1.29.7"

  default_node_pool {
    name                = "system"
    node_count          = var.node_count
    vm_size             = var.node_vm_size
    type                = "VirtualMachineScaleSets"
    orchestrator_version = null
    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "azure"  # or "azure" (CNI) recommended for most
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  # Enable critical addons if needed
  # oms_agent { ... } # if you plan to attach Log Analytics

  role_based_access_control_enabled = true

  tags = {
    env     = "dev"
    project = "aks"
  }
}