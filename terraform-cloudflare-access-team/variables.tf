variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "name" {
  type        = list(string)
  description = "Name of the token's intent"
}

variable "type" {
  type        = string
  description = "The teams list type. Valid values are IP, SERIAL, URL, DOMAIN, and EMAIL"
  default     = "EMAIL"
}

variable "description" {
  type        = string
  description = "The description of the teams list"
  default     = ""
}

variable "items" {
  type        = list(string)
  description = "The items of the teams list"
  default     = []
}