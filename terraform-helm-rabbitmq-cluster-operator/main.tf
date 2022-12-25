locals {
  rabbitmq_cluster_operator_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
    file("${path.module}/files/docker.yml")
  ]

  rabbitmq_cluster_operator_values = [for i in var.rabbitmq_cluster_operator_values : i]

  rabbitmq_cluster_operator = concat(local.rabbitmq_cluster_operator_default_values, local.rabbitmq_cluster_operator_values)
}

resource "helm_release" "rabbitmq-cluster-operator" {
  name       = "rabbitmq-cluster-operator"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq-cluster-operator"
  version    = "2.5.0"

  create_namespace = true
  namespace        = "rabbitmq"

  values = local.rabbitmq_cluster_operator
}

resource "kubernetes_manifest" "rabbitmq-cluster" {
  manifest = {
    "apiVersion" = "rabbitmq.com/v1beta1"
    "kind"       = "RabbitmqCluster"
    "metadata"   = {
      "name"      = "rabbitmq-cluster"
      "namespace" = "rabbitmq"
    }
    "spec" = {
      "replicas" = "1"
    }
  }

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    helm_release.rabbitmq-cluster-operator
  ]
}

resource "kubernetes_secret" "rabbitmq-cluster-users" {
  for_each = {for k, v in var.rabbitmq_cluster_users : k => v}

  metadata {
    name      = "rabbitmq-user-${each.value["username"]}"
    namespace = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.namespace
  }
  data = {
    username = each.value["username"]
    password = each.value["password"]
  }

  depends_on = [
    kubernetes_manifest.rabbitmq-cluster
  ]
}

resource "kubernetes_manifest" "rabbitmq-cluster-vhost" {
  manifest = {
    "apiVersion" = "rabbitmq.com/v1beta1"
    "kind"       = "Vhost"
    "metadata"   = {
      "name"      = "rabbitmq-cluster-vhost"
      "namespace" = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.namespace
    }
    "spec" = {
      "name"                     = "rabbitmq-cluster-vhost"
      "rabbitmqClusterReference" = {
        "name" = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.name
      }
    }
  }

  depends_on = [
    kubernetes_manifest.rabbitmq-cluster
  ]
}

resource "kubernetes_manifest" "rabbitmq-cluster-users" {
  for_each = {for k, v in var.rabbitmq_cluster_users : k => v}
  manifest = {
    "apiVersion" = "rabbitmq.com/v1beta1"
    "kind"       = "User"
    metadata     = {
      "name"      = kubernetes_secret.rabbitmq-cluster-users[each.key].metadata[0].name
      "namespace" = kubernetes_secret.rabbitmq-cluster-users[each.key].metadata[0].namespace
    }
    "spec" = {
      "rabbitmqClusterReference" = {
        "name" = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.name
      }
      "importCredentialsSecret" = {
        "name" = kubernetes_secret.rabbitmq-cluster-users[each.key].metadata[0].name
      }
    }
  }
  depends_on = [
    kubernetes_secret.rabbitmq-cluster-users,
    kubernetes_manifest.rabbitmq-cluster
  ]
}

resource "kubernetes_manifest" "rabbitmq-users-permission" {
  for_each = {for k, v in var.rabbitmq_cluster_users : k => v}
  manifest = {
    "apiVersion" = "rabbitmq.com/v1beta1"
    "kind"       = "Permission"
    "metadata"   = {
      "name"      = "rabbitmq-permission-${each.value["username"]}"
      "namespace" = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.namespace
    }
    "spec" = {
      "vhost"       = kubernetes_manifest.rabbitmq-cluster-vhost.manifest.metadata.name
      "user"        = kubernetes_manifest.rabbitmq-cluster-users[each.key].manifest.metadata.name
      "permissions" = {
        "write"     = ".*"
        "configure" = ""
        "read"      = ".*"
      }
      "rabbitmqClusterReference" = {
        "name" = kubernetes_manifest.rabbitmq-cluster.manifest.metadata.name
      }
    }
  }

  depends_on = [
    kubernetes_manifest.rabbitmq-cluster-vhost,
    kubernetes_manifest.rabbitmq-cluster-users
  ]
}