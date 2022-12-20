variable "name" {
  type = string
}

variable "replica" {
  type = number
}

variable "container" {
  type = object({
    image             = string
    name              = string
    image_pull_policy = string
    command           = list(string)
    args              = list(string)
  })
}

variable "labels" {
  type = map(any)
}

variable "registry" {
  sensitive = true
  type      = object({
    enabled  = bool
    host     = string
    username = string
    password = string
    email    = string
  })
  description = "The resource provides mechanisms to inject containers with sensitive information, such as passwords, while keeping containers agnostic of Kubernetes."
  default     = {
    enabled  = false
    host     = null
    username = null
    password = null
    email    = null
  }
}

variable "secret_environment_variables" {
  sensitive = true
  type      = set(object({
    key   = any
    value = any
  }))
  default = []
}

variable "environment_variables" {
  type = set(object({
    key   = any
    value = any
  }))
  default = []
}

variable "service_type" {
  type    = string
  default = "ClusterIP"
}

variable "service_port" {
  type = set(object({
    port   = number
    target = any
  }))
  default = [
    {
      port   = 80
      target = 80
    }
  ]
}