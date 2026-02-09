variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource group for AKS"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "test-cluster"
}

variable "node_count" {
  description = "Node count for default node pool"
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "VM size for default node pool"
  type        = string
  default     = "Standard_D2s_v5"
}

# Terraform state backend variables
variable "tfstate_resource_group" {
  type        = string
  description = "Resource group hosting the tfstate storage account"
}

variable "tfstate_storage_account" {
  type        = string
  description = "Storage account for tfstate"
}

variable "tfstate_container" {
  type        = string
  description = "Blob container for tfstate"
}