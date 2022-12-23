variable "name" {
  type = string
}

variable "type" {
  type        = string
  description = "The secret type"
  default     = "Opaque"
}

variable "metadata" {
  type = set(object({
    annotations = map(string)
    labels      = map(string)
    namespace   = string
  }))
}

variable "data" {
  type = set(object({
    key   = string
    value = string
  }))
  description = "A map of the secret data."
  default     = []
}
