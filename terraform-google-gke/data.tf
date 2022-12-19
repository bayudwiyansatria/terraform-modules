data "google_container_cluster" "cluster" {
  name     = google_container_cluster.cluster.name
  location = google_container_cluster.cluster.location

  depends_on = [
    google_container_cluster.cluster
  ]
}

data "google_client_config" "provider" {}