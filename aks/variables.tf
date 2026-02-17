
# variable "client_id" {
 
# }

# variable "client_password" {
  
# }

# variable "subscription_id" {
  
# }

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

# variable "tenant_id" {
#   default = "redhat0.onmicrosoft.com"
  
# }

# Terraform state backend variables
