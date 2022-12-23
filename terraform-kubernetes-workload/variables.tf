variable "name" {
  type = string
}

variable "replica" {
  type = number
}

variable "service_account_name" {
  type    = string
  default = null
}

variable "labels" {
  type = map(any)
}

variable "service" {
  type = object({
    type = string
    port = set(object({
      name     = string
      port     = number
      target   = any
      protocol = string
    }))
  })
  default = null
}

variable "ingress" {
  type = set(object({
    name     = string
    metadata = set(object({
      annotations = map(string)
      name        = string
      labels      = map(string)
    }))
    spec = set(object({
      rule = set(object({
        host = string
        http = set(object({
          path = set(object({
            path    = string
            backend = set(object({
              service_name = string
              service_port = string
            }))
          }))
        }))
      }))
      tls = set(object({
        secret_name = string
      }))
    }))
    wait_for_load_balancer = bool
  }))
  description = "Ingress is a collection of rules that allow inbound connections to reach the endpoints defined by a backend. An Ingress can be configured to give services externally-reachable urls, load balance traffic, terminate SSL, offer name based virtual hosting etc."
  default     = []
}

variable "container" {
  type = object({
    image             = string
    name              = string
    image_pull_policy = string
    environment       = set(object({
      prefix    = string
      configmap = set(object({
        name     = string
        optional = bool
      }))
      secret = set(object({
        name     = string
        optional = bool
      }))
    }))
    command = list(string)
    args    = list(string)
  })
}

#variable "init" {
#  type = object({
#    image             = string
#    name              = string
#    image_pull_policy = string
#    command           = list(string)
#    args              = list(string)
#  })
#}

variable "secret" {
  type = set(object({
    name = string
    type = string
    data = set(object({
      key   = string
      value = string
    }))
  }))
  default = []
}

variable "config" {
  type = set(object({
    name = string
    data = set(object({
      key   = string
      value = string
    }))
  }))
  default = []
}

variable "volumes" {
  type = set(object({
    mount_path        = string
    name              = string
    sub_path          = string
    mount_propagation = string
    read_only         = bool
    configmap         = set(object({
      default_mode = string
      name         = string
      optional     = string
    }))
  }))
  default = []
}
