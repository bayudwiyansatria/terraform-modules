variable "organization_id" {
  sensitive   = true
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable "team_name" {
  type        = string
  description = "MongoDB Access Team Name"
}

variable "team_member" {
  type        = list(string)
  description = "List Email of Team Member"
}