variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource group for AKS"
  type        = string
  default = ""
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
