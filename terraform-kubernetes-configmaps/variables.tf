variable "kubernetes_config_map_name" {
  type = string
}

variable "kubernetes_config_map_namespace" {
  type = string
}

variable "kubernetes_config_map_data" {
  type    = list(map(string))
  default = []
}