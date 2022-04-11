resource "kubernetes_config_map" "config_map" {
  metadata {
    name      = var.kubernetes_config_map_name
    namespace = var.kubernetes_config_map_namespace
  }

  data = {for k, v in var.kubernetes_config_map_data : v.key => v.value}
}
