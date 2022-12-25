variable "droplets" {
  sensitive = false
  type      = list(object({
    name  = string
    size  = string
    count = number,
  }))
  default = []
}

variable "vpc_id" {
  sensitive   = false
  type        = string
  description = "VPC Network ID"
}

variable "image" {
  sensitive   = false
  type        = string
  description = "Droplet Operation System"
}

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

variable "keys" {
  sensitive = false
  type      = list(string)
  default   = []
}