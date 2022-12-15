variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the AAD B2C Directory should exist. Changing this forces a new AAD B2C Directory to be created."
}

variable "display_name" {
  type        = string
  description = "The initial display name of the B2C tenant. Required when creating a new resource. Changing this forces a new AAD B2C Directory to be created."
}

variable "domain_name" {
  type        = string
  description = "Domain name of the B2C tenant, including the .onmicrosoft.com suffix. Changing this forces a new AAD B2C Directory to be created."
}

variable "country_code" {
  type        = string
  description = "Country code of the B2C tenant. The country_code should be valid for the specified data_residency_location. See official docs for valid country codes. Required when creating a new resource. Changing this forces a new AAD B2C Directory to be created."
  default     = "ID"
}

variable "data_residency_location" {
  type        = string
  description = "Location in which the B2C tenant is hosted and data resides. The data_residency_location should be valid for the specified country_code. See official docs for more information. Changing this forces a new AAD B2C Directory to be created. Possible values are Asia Pacific, Australia, Europe, Global and United States."
  default     = "Asia Pacific"
}

variable "sku_name" {
  type        = string
  description = "Billing SKU for the B2C tenant. Must be one of: PremiumP1 or PremiumP2 (Standard is not supported). See official docs for more information."
  default     = "PremiumP1"
}

variable "tags" {
  type        = map(any)
  description = "(Optional) A mapping of tags which should be assigned to the AAD B2C Directory."
  default     = {}
}