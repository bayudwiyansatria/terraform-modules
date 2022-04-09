variable "external_dns_values" {
  sensitive = true
  type      = list(string)
  default   = []
}