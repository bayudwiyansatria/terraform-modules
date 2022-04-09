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
  ssh_keys = [
    "7b:33:e5:91:ad:a9:4e:21:58:58:24:e6:57:0c:96:64"
  ]
  vpc_uuid = var.vpc_id
}