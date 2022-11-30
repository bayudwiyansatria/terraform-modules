resource "mongodbatlas_teams" "team" {
  org_id    = var.organization_id
  name      = var.team_name
  usernames = var.team_member
}