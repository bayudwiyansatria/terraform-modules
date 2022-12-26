locals {
  keycloak_values_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/docker.yml"),
    file("${path.module}/files/network.yml"),
    file("${path.module}/files/ingress.yml"),
    file("${path.module}/files/resource.yml"),
  ]

  keycloak_values_values = [for i in var.keycloak_values : i]

  keycloak_values = concat(local.keycloak_values_default_values, local.keycloak_values_values)

}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "keycloak"
  version    = "13.0.0"

  create_namespace = true
  namespace        = "keycloak"

  values = local.keycloak_values
}
