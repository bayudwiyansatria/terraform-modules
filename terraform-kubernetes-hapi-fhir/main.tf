resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    annotations = {

    }
    name = var.kubernetes_name
  }

  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = kubernetes_service.service.metadata.0.name
        port {
          number = 8080
        }
      }
    }

    rule {
      host = var.domain_name
      http {
        path {
          backend {
            service {
              name = kubernetes_service.service.metadata.0.name
              port {
                number = 8080
              }
            }
          }

          path = "/*"
        }
      }
    }

    tls {
      secret_name = replace(var.domain_name, ".", "-")
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name   = var.kubernetes_name
    labels = var.kubernetes_label
  }
  spec {
    selector = var.kubernetes_label
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_config_map" "config" {
  metadata {
    name = "${var.kubernetes_name}-config"
  }

  data = {
    "application.yml" = var.application_config
  }
}

resource "kubernetes_config_map" "environment" {
  metadata {
    name = "${var.kubernetes_name}-environment"
  }

  data = var.kubernetes_config_environment
}

resource "kubernetes_secret" "environment" {
  metadata {
    name = "${var.kubernetes_name}-environment"
  }
  data = var.kubernetes_secret_environment
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name   = var.kubernetes_name
    labels = var.kubernetes_label
  }

  spec {
    replicas = var.kubernetes_replicas

    selector {
      match_labels = var.kubernetes_label
    }

    template {
      metadata {
        labels = var.kubernetes_label
      }

      spec {
        volume {
          name = "spring-config"
          config_map {
            name         = "${var.kubernetes_name}-config"
            default_mode = "0644"
          }
        }

        container {
          image             = "hapiproject/hapi:latest"
          name              = "hapi-fhir"
          image_pull_policy = "Always"

          env_from {
            config_map_ref {
              name = "${var.kubernetes_name}-environment"
            }
          }

          env_from {
            secret_ref {
              name = "${var.kubernetes_name}-environment"
            }
          }

          volume_mount {
            mount_path = "/conf"
            name       = "spring-config"
          }

          port {
            container_port = 8080
            protocol       = "TCP"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map.environment,
    kubernetes_secret.environment,
    kubernetes_service.service,
    kubernetes_config_map.config
  ]
}