variable "organization_id" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable "teams" {
  type        = list(any)
  description = "MongoDB Access Team Name"
}