resource "kubernetes_secret" "registry" {
  count = var.registry.enabled ? 1 : 0
  metadata {
    name = "${var.registry.host}-${var.name}-registry"
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        (var.registry.host) = {
          "username" = var.registry.username
          "password" = var.registry.username
          "email"    = var.registry.email
          "auth"     = base64encode("${var.registry.username}:${var.registry.password}")
        }
      }
    })
  }
  immutable = false
}

resource "kubernetes_secret" "secret_environment_variables" {
  count = var.secret_environment_variables ? 1 : 0
  metadata {
    name = "${var.name}-environment"
  }

  data = {
    for i in toset(var.secret_environment_variables) : i.key => i.value
  }
}

resource "kubernetes_config_map" "environment_variables" {
  count = var.environment_variables ? 1 : 0
  metadata {
    name = "${var.name}-environment"
  }
  data = {
    for i in toset(var.environment_variables) : i.key => i.value
  }
}


resource "kubernetes_service_account" "service_account" {
  count = length(kubernetes_secret.registry)
  metadata {
    name = var.name
  }

  secret {
    name = kubernetes_secret.registry[count.index].metadata.0.name
  }

  secret {
    name = kubernetes_secret.secret_environment_variables.metadata.0.name
  }

  image_pull_secret {
    name = kubernetes_secret.registry[count.index].metadata.0.name
  }

  depends_on = [
    kubernetes_secret.registry
  ]
}

resource "kubernetes_service" "service" {
  metadata {
    name = var.name
  }
  spec {
    selector = var.labels

    dynamic "port" {
      for_each = var.service_port
      content {
        port        = port.value.port
        target_port = port.value.target
      }
    }
    type = var.service_type
  }
}

resource "kubernetes_deployment" "apps" {
  metadata {
    name   = var.name
    labels = var.labels
  }

  spec {
    replicas = var.replica

    selector {
      match_labels = var.labels
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        container {
          image             = var.container.image
          name              = var.container.name
          image_pull_policy = var.container.image_pull_policy

          env_from {
            config_map_ref {
              name = "${var.name}-environment"
            }
          }

          dynamic "port" {
            for_each = var.service_port
            content {
              container_port = port.value.target
              protocol       = "TCP"
            }
          }

          command = length(var.container.command) > 0 ?  var.container.command ? null

          args = var.container.args
        }
        service_account_name = length(kubernetes_service_account.service_account) > 0 ? kubernetes_service_account.service_account.0.metadata.0.name : null
      }
    }
  }

  depends_on = [
    kubernetes_service.service
  ]
}
