locals {
  postgres_default_values = [
    file("${path.module}/files/default.yml")
  ]

  postgres_values = [for i in var.postgres_values : i]

  postgres = concat(local.postgres_default_values, local.postgres_values)

}

resource "helm_release" "postgresql-ha" {
  name       = "postgresql-ha"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  version    = "8.6.8"

  create_namespace = true
  namespace        = "postgres"

  values = local.postgres
}