output "id" {
  sensitive   = false
  description = "Droplet Identifier"
  value       = digitalocean_droplet.droplet[*].id
  depends_on  = [
    digitalocean_droplet.droplet
  ]
}

output "ip_address" {
  sensitive   = false
  description = "Droplet IP Address"
  value       = digitalocean_droplet.droplet[*].ipv4_address
  depends_on  = [
    digitalocean_droplet.droplet
  ]
}