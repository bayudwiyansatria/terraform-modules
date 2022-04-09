locals {
  external_dns_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/docker.yml"),
  ]

  external_dns_values           = [for i in var.external_dns_values : i]

  external_dns = concat(local.external_dns_default_values, local.external_dns_values)
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "kube-system"

  values = local.external_dns
}
