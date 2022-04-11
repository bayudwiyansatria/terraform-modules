output "name" {
  value = kubernetes_config_map.config_map.metadata.0.name
}

output "namespace" {
  value = kubernetes_config_map.config_map.metadata.0.namespace
}