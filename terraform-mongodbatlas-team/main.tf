locals {
  team = {for k, v in var.teams : v.name => v.members}
}

resource "mongodbatlas_teams" "team" {
  for_each  = local.team
  org_id    = var.organization_id
  name      = each.key
  usernames = each.value
}