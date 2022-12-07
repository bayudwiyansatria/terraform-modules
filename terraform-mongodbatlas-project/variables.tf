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
    team_id = string

    // GROUP_OWNER, GROUP_READ_ONLY, GROUP_DATA_ACCESS_ADMIN, GROUP_DATA_ACCESS_READ_WRITE, GROUP_DATA_ACCESS_READ_ONLY, or/and GROUP_CLUSTER_MANAGER
    role_names = list(string)
  }))
  default = []
}

variable "api_keys" {
  type = set(object({
    api_key_id = string

    // GROUP_OWNER, GROUP_READ_ONLY, GROUP_DATA_ACCESS_ADMIN, GROUP_DATA_ACCESS_READ_WRITE, GROUP_DATA_ACCESS_READ_ONLY, or/and GROUP_CLUSTER_MANAGER
    role_names = list(string)
  }))
  default = []
}