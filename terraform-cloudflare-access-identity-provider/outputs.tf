output "id" {
  value = [
    for provider in cloudflare_access_identity_provider.provider : provider.id
  ]
}