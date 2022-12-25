variable "kubernetes_name" {
  type = string
}

variable "kubernetes_label" {
  type    = map(string)
  default = {}
}

variable "kubernetes_replicas" {
  type    = number
  default = 1
}

variable "domain_name" {
  type    = string
  default = ""
}