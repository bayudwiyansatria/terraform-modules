resource "google_compute_network" "network" {
  name                            = var.name
  description                     = var.description
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  mtu                             = var.mtu
  enable_ula_internal_ipv6        = var.enable_ula_internal_ipv6
  internal_ipv6_range             = var.internal_ipv6_range
  project                         = var.project
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

#resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
#  count =
#  name          = "test-subnetwork"
#  ip_cidr_range = "10.2.0.0/16"
#  region        = "us-central1"
#  network       = google_compute_network.custom-test.id
#  secondary_ip_range {
#    range_name    = "tf-test-secondary-range-update1"
#    ip_cidr_range = "192.168.10.0/24"
#  }
#}
