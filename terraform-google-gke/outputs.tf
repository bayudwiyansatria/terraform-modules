output "id" {
  value = google_container_cluster.cluster.id
}

output "node_pool_id" {
  value = [
    for i in google_container_node_pool.nodes : i.id
  ]
}

output "kube_config" {
  sensitive = true
  value     = google_container_cluster.cluster.master_auth
}