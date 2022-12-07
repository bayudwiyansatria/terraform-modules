resource "cloudflare_access_service_token" "account" {
  for_each             = toset(var.name)
  account_id           = var.account_id
  name                 = each.key
  min_days_for_renewal = 0

  lifecycle {
    create_before_destroy = true
  }
}