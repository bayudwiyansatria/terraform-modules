module "droplet" {
  count           = length(var.droplets)
  source          = "bayudwiyansatria/droplet/digitalocean"
  version         = "0.0.1"
  server_count    = var.droplets[count.index].count
  server_name     = var.droplets[count.index].name
  server_type     = var.droplets[count.index].size
  server_distro   = var.image
  server_location = var.region
  server_keys     = var.keys
  vpc_id          = var.vpc_id
  project_id      = var.project_id
}

output "id" {
  value      = flatten(module.droplet.*.ids)
  depends_on = [
    module.droplet
  ]
}

output "ipv4" {
  value      = flatten(module.droplet.*.ips)
  depends_on = [
    module.droplet
  ]
}
