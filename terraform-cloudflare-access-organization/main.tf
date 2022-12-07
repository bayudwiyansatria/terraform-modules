resource "cloudflare_access_organization" "organization" {
  account_id      = var.account_id
  name            = var.name
  auth_domain     = var.domain
  is_ui_read_only = var.is_read_only

  dynamic login_design {
    for_each = var.config
    content {
      background_color = "#ffffff"
      text_color       = "#000000"
      logo_path        = "https://example.com/logo.png"
      header_text      = "My header text"
      footer_text      = "My footer text"
    }
  }
}