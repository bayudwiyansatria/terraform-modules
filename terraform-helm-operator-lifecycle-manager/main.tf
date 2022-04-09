locals {
  olm_default_values = [
    file("${path.module}/files/default.yml")
  ]

  olm_values = [for i in var.olm_values : i]

  olm = concat(local.olm_default_values, local.olm_values)

}

resource "helm_release" "olm" {
  name       = "operator-lifecycle-manager"
  repository = "https://openebs.github.io/charts"
  chart      = "olm"
  version    = "0.0.0-dev"

  create_namespace = true
  namespace        = "operator"

  values = local.olm
}