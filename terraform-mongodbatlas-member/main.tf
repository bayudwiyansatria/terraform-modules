locals {
  member = {for k, v in var.members : v.username => v.roles}
}

resource "mongodbatlas_org_invitation" "member" {
  for_each = local.member
  org_id   = var.organization_id
  username = each.key
  roles    = each.value
}