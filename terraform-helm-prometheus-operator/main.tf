locals {
  operator_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/dependencies.yml")
  ]

  prometheus_default_values = [
    file("${path.module}/files/prometheus/default.yml"),
    file("${path.module}/files/prometheus/config.yml"),
    file("${path.module}/files/prometheus/docker.yml"),
    file("${path.module}/files/prometheus/ingress.yml"),
    file("${path.module}/files/prometheus/resource.yml"),
    file("${path.module}/files/prometheus/security.yml"),
    file("${path.module}/files/prometheus/storage.yml"),
    file("${path.module}/files/prometheus/thanos.yml"),
  ]

  grafana_default_values = [
    file("${path.module}/files/grafana/default.yml"),
    file("${path.module}/files/grafana/config.yml"),
    file("${path.module}/files/grafana/ingress.yml"),
    file("${path.module}/files/grafana/security.yml"),
    file("${path.module}/files/grafana/storage.yml")
  ]

  alert_manager_default_values = [
    file("${path.module}/files/alertmanager/default.yml"),
    file("${path.module}/files/alertmanager/config.yml"),
    file("${path.module}/files/alertmanager/ingress.yml"),
    file("${path.module}/files/alertmanager/security.yml"),
    file("${path.module}/files/alertmanager/storage.yml")
  ]

  operator_values      = [for i in var.operator_values : i]
  prometheus_values    = [for i in var.prometheus_values : i]
  grafana_values       = [for i in var.grafana_values : i]
  alert_manager_values = [for i in var.alert_manager_values : i]

  operator      = concat(local.operator_default_values, local.operator_values)
  prometheus    = concat(local.prometheus_default_values, local.prometheus_values)
  grafana       = concat(local.grafana_default_values, local.grafana_values)
  alert_manager = concat(local.alert_manager_default_values, local.alert_manager_values)
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "34.0.0"

  create_namespace = true
  namespace        = "monitoring"

  values = concat(local.operator, local.prometheus, local.alert_manager, local.grafana_values)
}
