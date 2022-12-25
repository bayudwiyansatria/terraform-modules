locals {
  thanos_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/dependencies.yml")
  ]

  thanos_storage_gateway_default_values = [
    file("${path.module}/files/storage-gateway/default.yml"),
    file("${path.module}/files/storage-gateway/ingress.yml"),
    file("${path.module}/files/storage-gateway/storage.yml"),
  ]

  thanos_ruler_default_values = [
    file("${path.module}/files/ruler/default.yml"),
    file("${path.module}/files/ruler/ingress.yml"),
    file("${path.module}/files/ruler/storage.yml"),
  ]

  thanos_receive_default_values = [
    file("${path.module}/files/receive/default.yml"),
    file("${path.module}/files/receive/ingress.yml"),
    file("${path.module}/files/receive/storage.yml"),
    file("${path.module}/files/receive/network.yml"),
  ]

  thanos_query_frontend_default_values = [
    file("${path.module}/files/query-frontend/default.yml"),
    file("${path.module}/files/query-frontend/ingress.yml"),
  ]

  thanos_query_default_values = [
    file("${path.module}/files/query/default.yml"),
    file("${path.module}/files/query/ingress.yml"),
  ]

  thanos_compactor_default_values = [
    file("${path.module}/files/compactor/default.yml"),
    file("${path.module}/files/compactor/ingress.yml"),
    file("${path.module}/files/compactor/storage.yml"),
  ]

  thanos_bucket_web_default_values = [
    file("${path.module}/files/bucket-web/default.yml"),
    file("${path.module}/files/bucket-web/ingress.yml"),
  ]

  thanos_values                 = [for i in var.thanos_values : i]
  thanos_storage_gateway_values = [for i in var.thanos_storage_gateway_values : i]
  thanos_ruler_values           = [for i in var.thanos_ruler_values : i]
  thanos_receive_values         = [for i in var.thanos_receive_values : i]
  thanos_query_frontend_values  = [for i in var.thanos_query_frontend_values : i]
  thanos_query_values           = [for i in var.thanos_query_values : i]
  thanos_compactor_values       = [for i in var.thanos_compactor_values : i]
  thanos_bucket_web_values      = [for i in var.thanos_bucket_web_values : i]

  thanos_storage        = concat(local.thanos_storage_gateway_default_values, local.thanos_storage_gateway_values)
  thanos_ruler          = concat(local.thanos_ruler_default_values, local.thanos_ruler_values)
  thanos_receive        = concat(local.thanos_receive_default_values, local.thanos_receive_values)
  thanos_query_frontend = concat(local.thanos_query_frontend_default_values, local.thanos_query_frontend_values)
  thanos_query          = concat(local.thanos_query_default_values, local.thanos_query_values)
  thanos_compactor      = concat(local.thanos_compactor_default_values, local.thanos_compactor_values)
  thanos_bucket_web     = concat(local.thanos_bucket_web_default_values, local.thanos_bucket_web_values)

  minio_default_values = [
    file("${path.module}/files/minio/default.yml"),
    file("${path.module}/files/minio/security.yml"),
  ]
  minio_values = [for i in var.minio_values : i]
  minio        = concat(local.minio_default_values, local.minio_values)

  thanos = concat(
    local.thanos_default_values, local.thanos_values,
    local.thanos_storage,
    local.thanos_ruler,
    local.thanos_receive,
    local.thanos_query_frontend,
    local.thanos_query,
    local.thanos_compactor,
    local.thanos_bucket_web,
    local.minio
  )

}

resource "helm_release" "thanos" {
  name       = "thanos"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "thanos"
  version    = "10.1.1"

  create_namespace = true
  namespace        = "thanos"

  values = local.thanos
}

resource "kubernetes_secret" "basic-auth" {
  metadata {
    name      = "basic-auth"
    namespace = "thanos"
  }

  data = { for k, v in var.http_authentication : v.username => v.password }

  depends_on = [
    helm_release.thanos
  ]
}