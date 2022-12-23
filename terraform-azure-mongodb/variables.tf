variable "database" {
  type = set(object({
    name = string
  }))
}