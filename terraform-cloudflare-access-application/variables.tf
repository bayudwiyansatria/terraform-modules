variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "domain" {
  type = set(object({
    name             = string
    host             = string
    // Available values: app_launcher, bookmark, biso, dash_sso, saas, self_hosted, ssh, vnc, warp
    type             = string
    session_duration = string
  }))
}

variable "cors" {
  type = set(object({
    allowed_methods   = string
    allowed_origins   = list(string)
    allow_credentials = bool
    max_age           = number
  }))
  default = []
}