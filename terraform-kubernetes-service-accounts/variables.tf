variable "account" {
  type = set(object({
    name                            = string
    automount_service_account_token = bool
    metadata                        = set(object({
      annotations = map(string)
      labels      = map(string)
      namespace   = string
    }))
    image_pull_secret = set(object({
      name = string
    }))
    secret = set(object({
      name = string
    }))
  }))
}