resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-body-size" = "1g"
    }
    name = var.kubernetes_name
  }

  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = kubernetes_service.snow_storm_frontend.metadata.0.name
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
              name = kubernetes_service.snow_storm_frontend.metadata.0.name
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

resource "kubernetes_service" "snow_storm_frontend" {
  metadata {
    name   = "${var.kubernetes_name}-frontend"
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

resource "kubernetes_deployment" "snow_storm" {
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
        container {
          image             = "snomedinternational/snowstorm:5.0.7"
          name              = "snowstorm-frontend"
          image_pull_policy = "Always"

          env {
            name  = "ES_JAVA_OPTS"
            value = "-Xms2g -Xmx4g"
          }

          port {
            container_port = 8080
            protocol       = "TCP"
          }

          args = [
            "--elasticsearch.urls=http://elasticsearch.elasticsearch:9200"
          ]
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.snow_storm_frontend
  ]
}