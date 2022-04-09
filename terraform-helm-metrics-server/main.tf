locals {
  metrics_server_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/docker.yml"),
  ]

  metrics_server_values = [for i in var.metrics_server_values : i]

  metrics_server = concat(local.metrics_server_default_values, local.metrics_server_values)

}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "5.11.4"

  create_namespace = true
  namespace        = "kube-system"

  values = local.metrics_server
}