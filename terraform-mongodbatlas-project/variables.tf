variable "organization_id" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable "projects" {
  type        = list(any)
  description = "MongoDB Access Team Name"
}

variable "teams" {
  type = set(object({
    team_id    = string
    role_names = list(string)
  }))
  default = []
}