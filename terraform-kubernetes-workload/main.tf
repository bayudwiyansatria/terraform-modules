resource "kubernetes_ingress_v1" "ingress" {
  for_each = {
    for k, v in toset(var.ingress) : v.name => k
  }

  dynamic "metadata" {
    for_each = {
      for k, v in toset(each.value.metadata) : v.name => k
    }
    content {
      name = metadata.value.name
    }
  }

  dynamic "spec" {
    for_each = each.value.spec
    content {

      dynamic "rule" {
        for_each = toset(spec.value.rule)
        content {
          host = rule.value.host

          dynamic "http" {
            for_each = toset(rule.value.http)
            content {

              dynamic "path" {
                for_each = http.value.path
                content {

                  path = path.value.path
                  dynamic "backend" {
                    for_each = path.value.backend
                    content {
                      service {
                        name = backend.value.service_name
                        port {
                          number = backend.value.service_port
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "tls" {
        for_each = toset(spec.value.tls)
        content {
          secret_name = tls.value.secret_name
        }
      }
    }
  }
  depends_on = [
    kubernetes_service.service
  ]
}

resource "kubernetes_secret" "secret" {
  for_each = {
    for k, v in toset(var.secret) : v.name => k
  }

  metadata {
    name = "${var.name}-${each.value.name}"
  }

  data = {
    for k, v in each.value.data : v.key => v.value
  }

  type = each.value.type
}

resource "kubernetes_config_map" "config" {
  for_each = {
    for k, v in toset(var.config) : v.name => k
  }

  metadata {
    name = "${var.name}-${each.value.name}"
  }

  data = {
    for k, v in each.value.data : v.key => v.value
  }

}

resource "kubernetes_service" "service" {
  count = var.service != null ? 1 : 0
  metadata {
    name = var.name
  }

  spec {
    selector = var.labels

    dynamic "port" {
      for_each = toset(var.service.port)
      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target
        protocol    = port.value.protocol
      }
    }
    type = var.service.type
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

          dynamic "env_from" {
            for_each = var.container.environment
            content {

              dynamic "config_map_ref" {
                for_each = env_from.value.configmap
                content {
                  name     = config_map_ref.value.name
                  optional = config_map_ref.value.optional
                }
              }

              dynamic "secret_ref" {
                for_each = env_from.value.secret
                content {
                  name     = secret_ref.value.name
                  optional = secret_ref.value.optional
                }
              }
            }
          }

          dynamic "port" {
            for_each = var.service != null ? {
              for k, v in var.service.port : v.name => k
              if v.name != null
            } : {}
            content {
              name           = port.value.name
              container_port = port.value.target
              protocol       = port.value.protocol
            }
          }

          dynamic "volume_mount" {
            for_each = var.volumes
            content {
              name              = volume_mount.value.name
              mount_path        = volume_mount.value.mount_path
              sub_path          = volume_mount.value.sub_path
              mount_propagation = volume_mount.value.mount_propagation
              read_only         = volume_mount.value.read_only
            }
          }

          command = length(var.container.command) > 0 ?  var.container.command : null
          args    = length(var.container.args) > 0 ?  var.container.args : null
        }

        dynamic "volume" {
          for_each = var.volumes
          content {
            name = volume.value.name

            dynamic "config_map" {
              for_each = volume.value.configmap
              content {
                name         = config_map.value.name
                default_mode = config_map.value.default_mode
                optional     = config_map.value.optional
              }
            }
          }
        }
        service_account_name = var.service_account_name != null ? var.service_account_name : null
      }

    }
  }

  depends_on = [
    kubernetes_secret.secret,
    kubernetes_config_map.config
  ]
}
