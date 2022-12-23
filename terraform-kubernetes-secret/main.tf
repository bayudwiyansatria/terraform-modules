resource "kubernetes_secret" "secret" {

  dynamic "metadata" {
    for_each = var.metadata
    content {
      name        = var.name
      namespace   = metadata.value.namespace
      annotations = metadata.value.annotations
      labels      = metadata.value.labels
    }
  }

  data = {
    for k, v in toset(var.data) : v.key => v.value
  }

  type = var.type
}
