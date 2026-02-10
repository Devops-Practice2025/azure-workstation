variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group for AKS"
  type        = string
  default = "openenv-rrv2r-1"
}

variable "client_id" {
  
}


variable "client_secret" {
  
}

variable "subscription_id" {
  
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

variable "tenant_id" {
  default = "redhat0.microsoft.com"
  
}

# Terraform state backend variables
