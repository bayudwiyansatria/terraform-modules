data "mongodbatlas_project" "project" {
  for_each   = toset(var.projects)
  project_id = each.key
}