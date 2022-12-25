locals {
  terraform_cloud_default_values = [
    file("${path.module}/files/default.yml"),
  ]

  terraform_cloud_values = [for i in var.terraform_values : i]

  terraform = concat(local.terraform_cloud_default_values, local.terraform_cloud_values)
}

resource "kubernetes_namespace" "terraform" {
  metadata {
    name = "terraform"
  }
}

resource "kubernetes_secret" "terraform-rc" {
  metadata {
    name      = "terraformrc"
    namespace = kubernetes_namespace.terraform.metadata.0.name
  }

  data = {
    "credentials" = var.terraform_cloud_key
  }

  depends_on = [
    kubernetes_namespace.terraform
  ]
}

resource "kubernetes_secret" "workspace-secrets" {
  metadata {
    name      = "workspacesecrets"
    namespace = kubernetes_namespace.terraform.metadata.0.name
  }

  data = { for k, v in var.terraform_workspace_key : v.key => v.value }

  depends_on = [
    kubernetes_secret.terraform-rc
  ]
}

resource "helm_release" "terraform-cloud" {
  chart      = "terraform"
  repository = "https://helm.releases.hashicorp.com"
  name       = "terraform"

  namespace = kubernetes_namespace.terraform.metadata.0.name

  values = local.terraform

  depends_on = [
    kubernetes_secret.workspace-secrets
  ]
}