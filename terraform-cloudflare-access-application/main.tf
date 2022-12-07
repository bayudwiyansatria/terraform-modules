resource "cloudflare_access_application" "application" {
  for_each         = {for k, v in var.domain : v.name => k}
  account_id       = var.account_id
  name             = each.value.name
  domain           = each.value.host
  type             = each.value.type
  session_duration = each.value.session_duration

  dynamic "cors_headers" {
    for_each = var.cors
    content {
      allowed_methods   = cors_headers.value.allowed_methods
      allowed_origins   = cors_headers.value.allowed_origins
      allow_credentials = cors_headers.value.allow_credentials
      max_age           = cors_headers.value.max_age
    }
  }
}