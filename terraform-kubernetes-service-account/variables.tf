variable "name" {
  type = string
}

variable "automount_service_account_token" {
  type    = bool
  default = true
}

variable "metadata" {
  type = set(object({
    annotations = map(string)
    labels      = map(string)
    namespace   = string
  }))
}

variable "image_pull_secret" {
  type = set(object({
    name = string
  }))
}

variable "secret" {
  type = set(object({
    name = string
  }))
}
