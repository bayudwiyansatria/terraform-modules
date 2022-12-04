resource "mongodbatlas_org_invitation" "member" {
  for_each = {for k, v in var.members : k => v}
  org_id   = var.organization_id
  username = each.value.name
  roles    = each.value.roles
}