resource "cloudflare_zone" "zone" {
  for_each   = toset(var.domain)
  account_id = var.account_id
  zone       = each.key
}