resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = "8.29.3"

  create_namespace = true
  namespace        = "rabbitmq"

  values = [
    data.template_file.rabbitmq_values.rendered
  ]

  set {
    name  = "fullnameOverride"
    value = "rabbitmq"
  }

  set {
    name  = "image.tag"
    value = "3.9.13"
  }

  set {
    name  = "auth.user"
    value = var.username
  }

  set {
    name  = "auth.password"
    value = var.password
  }
}