variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "domain" {
  type        = list(string)
  description = "The DNS zone name which will be added"
}