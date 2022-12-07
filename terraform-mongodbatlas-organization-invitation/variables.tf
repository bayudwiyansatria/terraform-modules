variable "organization_id" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable "members" {
  type        = list(any)
  description = "MongoDB Access Team Name"
}