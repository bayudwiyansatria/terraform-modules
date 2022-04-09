variable "kubernetes_name" {
  type    = string
  default = "openehr"
}

variable "kubernetes_label" {
  type    = map(string)
  default = {
    app = "openehr"
  }
}

variable "kubernetes_replicas" {
  type    = number
  default = 1
}

variable "kubernetes_config_environment" {
  type    = map(any)
  default = {}
}

variable "kubernetes_secret_environment" {
  sensitive = true
  type      = map(any)
  default   = {}
}

variable "domain_name" {
  type    = string
  default = ""
}