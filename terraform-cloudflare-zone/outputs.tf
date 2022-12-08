output "id" {
  value = [for i in cloudflare_zone.zone : i.id]
}