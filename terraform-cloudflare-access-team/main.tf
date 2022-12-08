resource "cloudflare_teams_list" "team" {
  for_each    = toset(var.name)
  account_id  = var.account_id
  name        = each.key
  type        = var.type
  description = var.description
  items       = var.items
}