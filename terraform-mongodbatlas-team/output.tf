output "id" {
  value = [for team in mongodbatlas_teams.team : team.team_id]
}

output "name" {
  value = [for team in mongodbatlas_teams.team : team.name]
}
