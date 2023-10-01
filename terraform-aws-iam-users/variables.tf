variable "users" {
  type = set(object({
    name                 = string
    path                 = string
    permissions_boundary = string
    force_destroy        = bool
  }))
  default = [
    {
      name                 = ""
      path                 = "/"
      permissions_boundary = ""
      force_destroy        = false
    }
  ]
}
