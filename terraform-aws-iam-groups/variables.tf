variable "groups" {
  type = set(object({
    name = string
    path = string
  }))
  default = [
    {
      name = ""
      path = "/"
    }
  ]
}
