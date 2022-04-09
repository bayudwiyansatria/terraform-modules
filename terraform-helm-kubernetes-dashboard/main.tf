locals {
  kubernetes_dashboard_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/docker.yml"),
    file("${path.module}/files/network.yml"),
    file("${path.module}/files/ingress.yml"),
    file("${path.module}/files/resource.yml"),
  ]

  kubernetes_dashboard_values = [for i in var.kubernetes_dashboard_values : i]

  kubernetes_dashboard = concat(local.kubernetes_dashboard_default_values, local.kubernetes_dashboard_values)

}

resource "helm_release" "kubernetes-dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  version    = "5.3.1"

  create_namespace = true
  namespace        = "kube-system"

  values = local.kubernetes_dashboard
}