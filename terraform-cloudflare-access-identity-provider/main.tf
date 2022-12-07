resource "cloudflare_access_identity_provider" "provider" {
  for_each   = toset(var.type)
  account_id = var.account_id
  name       = each.key
  type       = each.key
}