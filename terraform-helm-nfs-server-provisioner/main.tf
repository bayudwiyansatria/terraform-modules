locals {
  nfs_server_provisioner_default_values = [
    file("${path.module}/files/default.yml"),
    file("${path.module}/files/system.yml"),
  ]

  nfs_server_provisioner_values = [for i in var.nfs_server_provisioner_values : i]

  nfs_server_provisioner = concat(local.nfs_server_provisioner_default_values, local.nfs_server_provisioner_values)

}

resource "helm_release" "nfs-server-provisioner" {
  name       = "nfs-server-provisioner"
  repository = "https://charts.helm.sh/stable"
  chart      = "nfs-server-provisioner"
  version    = "1.1.3"

  create_namespace = true
  namespace        = "kube-system"

  values = local.nfs_server_provisioner
}