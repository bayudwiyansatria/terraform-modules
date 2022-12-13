output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_admin_config_raw
}