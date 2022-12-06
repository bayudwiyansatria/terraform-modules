output "id" {
  value = values(mongodbatlas_project.project)[*].id
}