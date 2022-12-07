resource "cloudflare_account" "account" {
  name              = var.name
  type              = var.type
  enforce_twofactor = var.mfa_enabled
}