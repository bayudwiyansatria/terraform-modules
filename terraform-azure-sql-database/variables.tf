variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group"
}

variable "mssql_server_id" {
  type        = string
  description = "The id of the MS SQL Server on which to create the database"
}

variable "mssql_database_name" {
  type        = string
  description = "The name of the MS SQL Database. Changing this forces a new resource to be created."
}

variable "mssql_database_auto_pause_delay_in_minutes" {
  type        = number
  description = "Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases."
  default     = 60
}

variable "mssql_create_mode" {
  type        = string
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary."
  default     = "Default"
}

variable "mssql_import" {
  type        = string
  description = "A Database Import block as documented below"
  default     = null
}

variable "mssql_creation_source_database_id" {
  type        = string
  description = "The ID of the source database from which to create the new database. This should only be used for databases with create_mode values that use another database as reference."
  default     = null
}

variable "mssql_collation" {
  type        = string
  description = "Specifies the collation of the database"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "mssql_database_license_type" {
  type        = string
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
  default     = "LicenseIncluded"
}

variable "mssql_database_max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes."
  default     = 1
}

variable "mssql_database_read_scale" {
  type        = bool
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
  default     = true
}

variable "mssql_database_sku_name" {
  type        = string
  description = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  default     = "S0"
}

variable "mssql_database_zone_redundant" {
  type        = bool
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
  default     = false
}

variable "mssql_database_storage_account_type" {
  type        = string
  description = "Specifies the storage account type used to store backups for this database. Possible values are Geo, Local and Zone"
  default     = "Local"
}
