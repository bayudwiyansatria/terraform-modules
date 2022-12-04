variable "organization_id" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable "team" {
  type = set(object({
    name   = string
    member = list(string)
  }))
  description = "MongoDB Access Team Name"
}