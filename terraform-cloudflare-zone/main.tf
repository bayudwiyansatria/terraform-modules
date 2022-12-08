resource "cloudflare_zone" "zone" {
  for_each = {
    for tuple in var.domain : replace(tuple, ".", "-") => {
      zone = tuple
    }
  }
  account_id = var.account_id
  zone       = each.value.zone
}