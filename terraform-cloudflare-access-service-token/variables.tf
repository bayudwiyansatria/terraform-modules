variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "name" {
  type        = list(string)
  description = "Name of the token's intent"
}