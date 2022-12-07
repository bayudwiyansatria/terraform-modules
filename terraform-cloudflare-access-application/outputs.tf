output "id" {
  value = [
    for app in cloudflare_access_application.application : app.id
  ]
}