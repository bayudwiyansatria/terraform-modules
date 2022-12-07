output "client" {
  sensitive = true
  value     = [
    for k, v in cloudflare_access_service_token.account : {
      id            = v.id
      client_id     = v.client_id
      client_secret = v.client_secret
    }
  ]
}