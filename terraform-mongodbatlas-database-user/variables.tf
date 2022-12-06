variable "projects" {
  type        = list(any)
  description = "MongoDB Atlas Project Id"
}

variable "users" {
  type = set(object({
    username                = string
    password                = string
    authentication_database = string
  }))
}

variable "roles" {
  type = set(object({
    role_name     = string
    database_name = string
  }))
}

variable "scopes" {
  type = set(object({
    name = string
    type = string  //Valid values are: CLUSTER and DATA_LAKE
  }))
}