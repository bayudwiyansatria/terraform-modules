variable "terraform_cloud_key" {
  sensitive = true
  type      = string
}

variable "terraform_workspace_key" {
  type      = list(map(string))
}

variable "terraform_values" {
  type    = list(string)
  default = []
}