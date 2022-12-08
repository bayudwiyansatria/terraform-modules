output "id" {
  value = [
    for i in cloudflare_teams_list.team : i.id
  ]
}