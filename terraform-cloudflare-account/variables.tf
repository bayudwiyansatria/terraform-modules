variable "name" {
  type        = string
  description = "The name of the account that is displayed in the Cloudflare dashboard."
}

variable "mfa_enabled" {
  type        = bool
  description = "Whether 2FA is enforced on the account"
  default     = false
}

// Modifying this attribute will force creation of a new resource.
variable "type" {
  type        = string
  description = "Account type.Available values: enterprise, standard"
  default     = "standard"
}