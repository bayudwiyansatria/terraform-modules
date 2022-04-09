locals {
  nginx_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/config.yml"),
    file("${path.module}/files/docker.yml"),
    file("${path.module}/files/network.yml"),
    file("${path.module}/files/resource.yml")
  ]

  nginx_values = [for i in var.nginx_values : i]

  nginx = concat(local.nginx_default_values, local.nginx_values)

}

resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "9.0.9"

  create_namespace = true
  namespace        = "kube-system"

  values = local.nginx
}