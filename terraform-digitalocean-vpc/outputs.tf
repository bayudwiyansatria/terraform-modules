output "id" {
  sensitive   = false
  value       = digitalocean_vpc.network.id
  description = "Digital Ocean Network VPC Unique Identifier"
  depends_on  = [
    digitalocean_vpc.network
  ]
}