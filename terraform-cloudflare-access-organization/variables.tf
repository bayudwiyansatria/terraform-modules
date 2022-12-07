variable "domain" {
  type        = string
  description = "The unique subdomain assigned to your Zero Trust organization"
}

variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "name" {
  type        = string
  description = "The name of your Zero Trust organization"
}

variable "config" {
  type = set(object({
    background_color = string
    text_color       = string
    logo_path        = string
    header_text      = string
    footer_text      = string
  }))
  default = []
}

variable "is_read_only" {
  type        = bool
  description = "When set to true, this will disable all editing of Access resources via the Zero Trust Dashboard"
  default     = false
}