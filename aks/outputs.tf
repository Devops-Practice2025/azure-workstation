output "kube_admin_config" {
  description = "Admin kubeconfig (sensitive). Use only in secure contexts."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

output "kube_user_config" {
  description = "User kubeconfig (sensitive)."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "ssh_private_key_pem" {
  description = "SSH private key (sensitive) - store securely"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}