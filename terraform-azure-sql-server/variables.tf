variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group"
}

variable "mssql_server_name" {
  type        = string
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
}

variable "mssql_server_version" {
  type        = string
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default     = "12.0"
}

variable "mssql_server_admin" {
  type        = string
  description = "The administrator login name for the new server."
}

variable "mssql_server_password" {
  type        = string
  description = "The password associated with the administrator user"
}

variable "mssql_server_connection_policy" {
  type        = string
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect."
  default     = "Default"
}

variable "mssql_server_transparent_data_encryption_key_vault_key_id" {
  type        = string
  description = "The fully versioned Key Vault Key"
  default     = null
}

variable "mssql_server_minimum_tls_version" {
  type        = string
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 , 1.2 and Disabled"
  default     = "1.2"
}

variable "mssql_server_public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this server"
  default     = true
}

variable "mssql_server_outbound_network_restriction_enabled" {
  type        = bool
  description = "Whether outbound network traffic is restricted for this server."
  default     = false
}

variable "mssql_server_primary_user_assigned_identity_id" {
  type        = string
  description = "Specifies the primary user managed identity id"
  default     = null
}

variable "mssql_server_azuread_administrator" {
  type = set(object({
    login_username              = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = bool
  }))
  description = ""
  default     = []
}
