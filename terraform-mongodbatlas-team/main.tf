resource "mongodbatlas_teams" "team" {
  for_each  = {for k, v in var.teams : v.name => v.members}
  org_id    = var.organization_id
  name      = each.key
  usernames = each.value
}