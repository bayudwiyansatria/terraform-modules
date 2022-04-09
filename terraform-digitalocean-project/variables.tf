#---------------------------------------------------------------------------------------------------
# Project
#---------------------------------------------------------------------------------------------------
variable "digitalocean_project_name" {
  sensitive = false
  type      = string
}

variable "digitalocean_project_description" {
  sensitive = false
  type      = string
  default   = "A project to represent development resources."
}

variable "digitalocean_project_purpose" {
  sensitive = false
  type      = string
  default   = "SaaS"
}

variable "digitalocean_project_environment" {
  sensitive = false
  type      = string
  default   = "Development"
}

variable "digitalocean_project_region" {
  sensitive   = false
  type        = string
  description = "Region"
  default     = "sgp1"
}
