#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------
resource "digitalocean_vpc" "network" {
  name     = var.name
  region   = var.region
  ip_range = var.ip_range
}