resource "digitalocean_project" "project" {
  name        = var.digitalocean_project_name
  description = var.digitalocean_project_description
  purpose     = var.digitalocean_project_purpose
  environment = var.digitalocean_project_environment
}

output "project_id" {
  value       = digitalocean_project.project.id
  description = "Digital Ocean Project Workspaces Unique Identifier"
}

output "project_name" {
  value       = digitalocean_project.project.name
  description = "Digital Ocean Project Name"
}