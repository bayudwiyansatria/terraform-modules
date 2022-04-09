locals {
  elasticsearch_default_values = [
    file("${path.module}/files/default.yml")
  ]

  elasticsearch_values = [for i in var.elasticsearch_values : i]

  elasticsearch = concat(local.elasticsearch_default_values, local.elasticsearch_values)
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.17.1"

  create_namespace = true
  namespace        = "elasticsearch"

  values = local.elasticsearch
}
