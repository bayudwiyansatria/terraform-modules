variable "cert_manager_values" {
  type    = list(string)
  default = []
}

variable "kubernetes_namespace" {
  type    = string
  default = "cert-manager"
}

variable "certificate_mailing_address" {
  type = string
}