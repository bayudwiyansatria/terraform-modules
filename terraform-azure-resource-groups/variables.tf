variable "groups" {
  type = set(object({
    name     = string
    location = string
  }))
  description = "The Name and Location to which should be used for this Resource Group"
}
