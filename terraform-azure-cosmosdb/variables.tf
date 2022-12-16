variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to the Application Gateway should exist."
}

variable "name" {
  type        = string
  description = "Specifies the name of the CosmosDB Account. Changing this forces a new resource to be created."
}

variable "mongo_server_version" {
  type        = string
  description = "The Server Version of a MongoDB account. Possible values are 4.2, 4.0, 3.6, and 3.2."
  default     = "4.0"
}

variable "access_key_metadata_writes_enabled" {
  type        = bool
  description = "Is write operations on metadata resources (databases, containers, throughput) via account keys enabled"
  default     = true
}

variable "analytical_storage_enabled" {
  type        = bool
  description = "Enable Analytical Storage option for this Cosmos DB account. Defaults to false."
  default     = false
}

# create_mode only works when backup.type is Continuous.
variable "create_mode" {
  type        = string
  description = "The creation mode for the CosmosDB Account. Possible values are Default and Restore."
  default     = "Default"
}

variable "default_identity_type" {
  type        = string
  description = "The default identity for accessing Key Vault. Possible values are FirstPartyIdentity, SystemAssignedIdentity or start with UserAssignedIdentity."
  default     = "FirstPartyIdentity"
}

variable "enable_automatic_failover" {
  type        = bool
  description = "Enable automatic fail over for this Cosmos DB account."
  default     = false
}

variable "enable_free_tier" {
  type        = bool
  description = "Enable Free Tier pricing option for this Cosmos DB account. Defaults to false."
  default     = true
}

variable "enable_multiple_write_locations" {
  type        = bool
  description = "Enable multiple write locations for this Cosmos DB account."
  default     = false
}

variable "ip_range_filter" {
  type        = set(string)
  description = "CosmosDB Firewall Support: This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account. IP addresses/ranges must be comma separated and must not contain any spaces."
  default     = []
}


variable "is_virtual_network_filter_enabled" {
  type        = bool
  description = "Enables virtual network filtering for this Cosmos DB account."
  default     = false
}

variable "kind" {
  type        = string
  description = "Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB, MongoDB and Parse"
  default     = "MongoDB"
}

# When referencing an azurerm_key_vault_key resource, use versionless_id instead of id
# In order to use a Custom Key from Key Vault for encryption you must grant Azure Cosmos DB Service access to your key vault. For instructions on how to configure your Key Vault correctly please refer to the product documentation
variable "key_vault_key_id" {
  type        = string
  description = "A versionless Key Vault Key ID for CMK encryption. Changing this forces a new resource to be created."
  default     = null
}

variable "local_authentication_disabled" {
  type        = bool
  description = "Disable local authentication and ensure only MSI and AAD can be used exclusively for authentication."
  default     = false
}

variable "network_acl_bypass_for_azure_services" {
  type        = bool
  description = "If Azure services can bypass ACLs."
  default     = false
}

variable "network_acl_bypass_ids" {
  type        = list(string)
  description = "The list of resource Ids for Network Acl Bypass for this Cosmos DB account."
  default     = []
}

variable "offer_type" {
  type        = string
  description = "Specifies the Offer Type to use for this CosmosDB Account"
  default     = "Standard"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether or not public network access is allowed for this CosmosDB account."
  default     = false
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "capabilities" {
  type        = set(string)
  description = "The capability to enable - Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableTable, EnableServerless, MongoDBv3.4 and mongoEnableDocLevelTTL"
  default     = [
    "EnableAggregationPipeline",
    "mongoEnableDocLevelTTL",
    "EnableMongo"
  ]
}

variable "geo_location" {
  type = set(object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
  }))
  description = "Configures the geographic locations the data is replicated to"
  default     = [
    {
      location          = "southeastasia"
      failover_priority = 0
      zone_redundant    = false
    }
  ]
}

variable "consistency_policy" {
  type = set(object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
  }))
  description = "Configures the database consistency"
  default     = [
    {
      consistency_level       = "BoundedStaleness"
      max_interval_in_seconds = 300
      max_staleness_prefix    = 100000
    }
  ]
}

variable "virtual_network_rule" {
  type = set(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = bool
  }))
  description = "Configures the virtual network subnets allowed to access this Cosmos DB account"
  default     = []
}

variable "analytical_storage" {
  type        = set(string)
  description = "The schema type of the Analytical Storage for this Cosmos DB account."
  default     = []
}

variable "capacity" {
  type        = set(number)
  description = "The total throughput limit imposed on this Cosmos DB account (RU/s)"
  default     = []
}

variable "backup" {
  type = set(object({
    # The type of the backup. Possible values are Continuous and Periodic
    type                = string
    interval_in_minutes = number
    retention_in_hours  = number
    storage_redundancy  = string
  }))
  description = ""
  default     = []
}

variable "cors_rule" {
  type = set(object({
    allowed_headers    = list(string)
    # Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  description = ""
  default     = []
}

variable "identity" {
  type = set(object({
    type = string
  }))
  description = ""
  default     = [
    {
      type = "SystemAssigned"
    }
  ]
}

variable "restore" {
  type = set(object({
    source_cosmosdb_account_id = string
    restore_timestamp_in_utc   = any
    database                   = set(object({
      name             = string
      collection_names = set(string)
    }))
  }))
  description = ""
  default     = []
}