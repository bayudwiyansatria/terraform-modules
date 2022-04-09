locals {
  openebs_default_values = [
    file("${path.module}/files/default.yml")
  ]

  openebs_values = [for i in var.openebs_values : i]

  openebs = concat(local.openebs_default_values, local.openebs_values)

}

resource "helm_release" "openebs" {
  name       = "openebs"
  repository = "https://openebs.github.io/charts"
  chart      = "openebs"
  version    = "3.1.0"

  create_namespace = true
  namespace        = "openebs"

  values = local.openebs
}