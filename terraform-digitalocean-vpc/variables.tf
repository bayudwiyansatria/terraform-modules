#---------------------------------------------------------------------------------------------------
# Digital Ocean
#---------------------------------------------------------------------------------------------------
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
  description = "Virtual Private Cloud Name"
}

#---------------------------------------------------------------------------------------------------
# VPC
#---------------------------------------------------------------------------------------------------
variable "ip_range" {
  sensitive   = false
  type        = string
  description = "Virtual Private Cloud IP Range CIDR"
}