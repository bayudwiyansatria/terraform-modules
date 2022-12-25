locals {
  grafana_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/config.yml"),
    file("${path.module}/files/ingress.yml"),
    file("${path.module}/files/security.yml"),
    file("${path.module}/files/storage.yml")
  ]
  grafana_values = [for i in var.grafana_values : i]

  namespace = length(data.kubernetes_namespace.grafana_namespace.metadata) > 0 ? data.kubernetes_namespace.grafana_namespace.metadata.0.name : "monitoring"
}

data "kubernetes_namespace" "grafana_namespace" {
  metadata {
    name = "monitoring"
  }
}

data "kubernetes_ingress" "endpoint" {
  metadata {
    name      = "prometheus-grafana"
    namespace = local.namespace
  }
  depends_on = [
    helm_release.grafana
  ]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = local.namespace
  repository = "https://grafana.github.io/helm-charts"

  chart   = "grafana"
  version = "6.22.0"

  create_namespace = true

  values = concat(local.grafana_default_values, local.grafana_values)
}

output "namespace" {
  value = local.namespace
}

output "ingress" {
  value = data.kubernetes_ingress.endpoint
}