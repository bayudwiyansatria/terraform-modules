variable "kubernetes_name" {
  type    = string
  default = "hapi-fhir"
}

variable "kubernetes_label" {
  type    = map(string)
  default = {
    app = "hapi-fhir"
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

variable "application_config" {
  sensitive = true
  type      = string
}

variable "domain_name" {
  type = string
}