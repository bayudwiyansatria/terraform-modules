resource "digitalocean_project_resources" "project_resources" {
  count     = var.server_count
  project   = var.project_id
  resources = [
    digitalocean_droplet.droplet[count.index].urn
  ]
  depends_on = [
    digitalocean_droplet.droplet
  ]
}

#---------------------------------------------------------------------------------------------------
# Droplet
#---------------------------------------------------------------------------------------------------
resource "digitalocean_droplet" "droplet" {
  count    = var.server_count
  image    = var.image
  name     = "${var.name}-${count.index + 1}"
  region   = var.region
  size     = var.size
  ssh_keys = var.server_keys
  vpc_uuid = var.vpc_id
}