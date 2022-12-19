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
  value     = [
    {
      host                   = "https://${data.google_container_cluster.cluster.endpoint}"
      token                  = data.google_client_config.provider.access_token
      cluster_ca_certificate = data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
    }
  ]
  depends_on = [
    data.google_container_cluster.cluster
  ]
}