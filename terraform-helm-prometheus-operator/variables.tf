variable "operator_values" {
  type    = list(string)
  default = []
}

variable "prometheus_values" {
  type    = list(string)
  default = []
}

variable "grafana_values" {
  type    = list(string)
  default = []
}

variable "alert_manager_values" {
  type    = list(string)
  default = []
}

variable "thanos_enabled" {
  type    = bool
  default = false
}

variable "thanos_values" {
  type    = string
  default = ""
}