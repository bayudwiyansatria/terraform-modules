output "id" {
  value = google_container_cluster.cluster.id
}

output "kube_config" {
  sensitive = true
  value     = google_container_cluster.cluster.master_auth
}