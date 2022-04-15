#---------------------------------------------------------------------------------------------------
# Digital Ocean
#---------------------------------------------------------------------------------------------------
variable "project_id" {
  sensitive   = false
  type        = string
  description = "Digital Ocean Kubernetes Deployment Project Identifier"
}

variable "region" {
  sensitive   = false
  type        = string
  description = "Digital Ocean Kubernetes Deployment Region"
}

#---------------------------------------------------------------------------------------------------
# Common
#---------------------------------------------------------------------------------------------------
variable "name" {
  sensitive   = false
  type        = string
  description = "Droplet Name"
}

#---------------------------------------------------------------------------------------------------
# Droplet
#---------------------------------------------------------------------------------------------------
variable "server_count" {
  sensitive = false
  type      = number
  default   = 1
}

variable "server_keys" {
  sensitive = false
  type      = number
  default   = []
}

variable "vpc_id" {
  sensitive   = false
  type        = string
  description = "VPC Network ID"
}

variable "size" {
  sensitive   = false
  type        = string
  description = "Droplet size"
}

variable "image" {
  sensitive   = false
  type        = string
  description = "Droplet Operation System"
}