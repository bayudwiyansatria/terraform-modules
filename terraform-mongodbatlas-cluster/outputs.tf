output "id" {
  value = values(mongodbatlas_advanced_cluster.cluster)[*].cluster_id
}