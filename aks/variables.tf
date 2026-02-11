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
  default = "0f8b470f-d23b-477a-a0ce-e7db6cf2d265"
}


variable "subscription_id" {
  default = "6944b66d-1ac0-445c-81c2-26aa49d120c3"
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
  default = "redhat0.onmicrosoft.com"
  
}

# Terraform state backend variables
