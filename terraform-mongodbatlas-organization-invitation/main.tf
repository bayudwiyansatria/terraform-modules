resource "mongodbatlas_org_invitation" "member" {
  for_each = {
    for k, v in var.members:
    v.username => v.roles
  }
  org_id   = var.organization_id
  username = each.key
  roles    = each.value
}