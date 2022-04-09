locals {
  cert_manager_default_values = [
    file("${path.module}/files/default.yml")
  ]

  cert_manager_values = [for i in var.cert_manager_values : i]

  cert_manager = concat(local.cert_manager_default_values, local.cert_manager_values)

}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.7.2"

  create_namespace = true
  namespace        = "cert-manager"

  values = local.cert_manager
}

resource "kubernetes_manifest" "certificate-issuer-staging" {
  manifest = {
    "apiVersion" : "cert-manager.io/v1"
    "kind" : "ClusterIssuer"
    "metadata" : {
      "name" : "letsencrypt-staging"
    }
    "spec" : {
      "acme" : {
        "email" : "bayudwiyansatria@gmail.com"
        "server" : "https://acme-staging-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" : {
          name : "letsencrypt-staging"
        }
        "solvers" : [
          {
            "http01" : {
              "ingress" : {
                "class" : "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [
    helm_release.cert-manager
  ]
}

resource "kubernetes_manifest" "certificate-issuer-production" {
  manifest = {
    "apiVersion" : "cert-manager.io/v1"
    "kind" : "ClusterIssuer"
    "metadata" : {
      "name" : "letsencrypt-production"
    }
    "spec" : {
      "acme" : {
        "email" : "bayudwiyansatria@gmail.com"
        "server" : "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" : {
          name : "letsencrypt-production"
        }
        "solvers" : [
          {
            "http01" : {
              "ingress" : {
                "class" : "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [
    helm_release.cert-manager
  ]
}