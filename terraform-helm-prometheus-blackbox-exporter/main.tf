locals {
  prometheus_blackbox_exporter_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/docker.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/config.yml"),
  ]

  prometheus_blackbox_exporter_values = [for i in var.prometheus_blackbox_exporter_values : i]
  prometheus_blackbox_exporter        = concat(local.prometheus_blackbox_exporter_default_values, local.prometheus_blackbox_exporter_values)
}

resource "helm_release" "prometheus_blackbox_exporter" {
  name       = "prometheus-blackbox-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-blackbox-exporter"
  version    = "5.7.0"

  create_namespace = true
  namespace        = "monitoring"

  values = local.prometheus_blackbox_exporter
}
