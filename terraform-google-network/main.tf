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

resource "google_compute_global_address" "address" {
  count         = var.enable_global_address ? 1 : 0
  name          = var.name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id

  depends_on = [
    google_compute_network.network
  ]
}

resource "google_service_networking_connection" "connection" {
  count                   = var.enable_network_peer ? 1 : 0
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.address[count.index].name
  ]

  depends_on = [
    google_compute_network.network,
    google_compute_global_address.address
  ]
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
