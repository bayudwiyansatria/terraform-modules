variable "projects" {
  type        = list(any)
  description = "MongoDB Atlas Project Id"
}

variable "ip_address" {
  type        = list(string)
  description = "List of IP Address to Access Clusters"
}