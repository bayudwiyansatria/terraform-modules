resource "mongodbatlas_teams" "team" {
  for_each  = var.team
  org_id    = var.organization_id
  name      = each.value.name
  usernames = each.value.member
}