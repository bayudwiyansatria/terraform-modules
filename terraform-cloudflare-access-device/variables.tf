variable "zone_id" {
  type        = string
  description = "The zone ID where certificate generation is allowed"
}

variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "enabled_certificate" {
  type        = bool
  description = "True if certificate generation is enabled"
  default     = true
}

variable "rule" {
  type        = string
  description = "The device posture rule type. Available values: serial_number, file, application, gateway, warp, domain_joined, os_version, disk_encryption, firewall, workspace_one, unique_client_id"
  default     = "unique_client_id"
}

variable "device_os" {
  type        = list(string)
  description = "The conditions that the client must match to run the rule"
  default     = [
    "windows",
    "linux",
    "mac",
    "android",
    "ios",
    "chromeos"
  ]
}

variable "team_id" {
  type        = list(string)
  description = "The Teams List id"
}

variable "enabled_integration" {
  type    = bool
  default = false
}

variable "integration_type" {
  type        = string
  description = "The device posture integration type. Valid values are workspace_one"
  default     = "workspace_one"
}

variable "integration_config" {
  type = set(object({
    api_url       = string
    auth_url      = string
    client_id     = string
    client_secret = string
    customer_id   = string
    client_key    = string
  }))
  description = "The The config structure depends on the integration type. Available ws1, crowdstrike_s2s, uptycs, intune"
  default     = []
}