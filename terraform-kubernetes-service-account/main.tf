resource "kubernetes_service_account" "service_account" {
  dynamic "metadata" {
    for_each = var.metadata
    content {
      name        = var.name
      namespace   = metadata.value.namespace
      annotations = metadata.value.annotations
      labels      = metadata.value.labels
    }
  }

  dynamic "secret" {
    for_each = var.secret
    content {
      name = secret.value.name
    }
  }

  dynamic "image_pull_secret" {
    for_each = var.image_pull_secret
    content {
      name = image_pull_secret.value.name
    }
  }
  automount_service_account_token = var.automount_service_account_token
}
