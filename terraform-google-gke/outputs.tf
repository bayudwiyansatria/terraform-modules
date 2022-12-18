output "id" {
  value = google_container_cluster.cluster.id
}

output "kube_config" {
  value = google_container_cluster.cluster.master_auth
}