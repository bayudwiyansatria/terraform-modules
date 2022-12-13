resource "cloudflare_device_settings_policy" "policy" {
  account_id = var.account_id
  name       = var.zone_id
}

resource "cloudflare_device_policy_certificates" "policy_certificate" {
  zone_id = var.zone_id
  enabled = var.enabled_certificate

  depends_on = [
    cloudflare_device_settings_policy.policy
  ]
}


resource "cloudflare_device_posture_rule" "rule" {
  account_id = var.account_id
  name       = var.zone_id
  type       = var.rule

  dynamic "match" {
    for_each = toset(var.device_os)
    content {
      platform = match.value
    }
  }

  dynamic "input" {
    for_each = var.team_id
    content {
      id = input.value
    }
  }

  depends_on = [
    cloudflare_device_policy_certificates.policy_certificate
  ]
}

resource "cloudflare_device_posture_integration" "integration" {
  count      = var.enabled_integration ? 1 : 0
  account_id = var.account_id
  name       = var.zone_id
  type       = var.integration_type

  dynamic config {
    for_each = var.integration_config
    content {
      api_url       = config.value.api_url
      auth_url      = config.value.auth_url ? 1 : 0
      client_id     = config.value.client_id
      client_secret = config.value.client_secret
    }
  }

  depends_on = [
    cloudflare_device_policy_certificates.policy_certificate
  ]
}