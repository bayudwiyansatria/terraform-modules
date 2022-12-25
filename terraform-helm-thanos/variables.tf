variable "thanos_values" {
  type    = list(string)
  default = []
}

variable "thanos_storage_gateway_values" {
  type    = list(string)
  default = []
}

variable "thanos_ruler_values" {
  type    = list(string)
  default = []
}

variable "thanos_receive_values" {
  type    = list(string)
  default = []
}

variable "thanos_query_frontend_values" {
  type    = list(string)
  default = []
}

variable "thanos_query_values" {
  type    = list(string)
  default = []
}

variable "thanos_compactor_values" {
  type    = list(string)
  default = []
}

variable "thanos_bucket_web_values" {
  type    = list(string)
  default = []
}

variable "minio_values" {
  type    = list(string)
  default = []
}

variable "http_authentication" {
  type    = list(map(string))
  default = []
}