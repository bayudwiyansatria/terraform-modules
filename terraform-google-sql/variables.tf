variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
}

variable "region" {
  type        = string
  description = "The region the instance will sit in. If a region is not provided in the resource definition, the provider region will be used instead."
}

variable "name" {
  type        = string
  description = "The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created. This is done because after a name is used, it cannot be reused for up to one week."
}

variable "database_version" {
  type        = string
  description = "The MySQL, PostgreSQL or SQL Server version to use. Supported values include MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, POSTGRES_14, SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB. SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS, SQLSERVER_2019_WEB"
}

variable "root_password" {
  type        = string
  description = "Initial root password. Required for MS SQL Server."
}

variable "settings" {
  type = set(object({
    tier                  = string
    activation_policy     = string
    availability_type     = string
    collation             = string
    #    connector_enforcement = bool
    disk_autoresize       = bool
    disk_autoresize_limit = number
    disk_size             = number
    disk_type             = string
    pricing_plan          = string
    user_labels           = map(any)
    database_flags        = set(object({
      name  = any
      value = any
    }))
    active_directory_config = set(object({
      domain = string
    }))
    #    deny_maintenance_period = set(object({
    #      # If the year of the date is empty, the year of the date also must be empty. In this case, it means the no maintenance interval recurs every year. The date is in format yyyy-mm-dd i.e., 2020-11-01, or mm-dd, i.e., 11-01
    #      end_date   = string
    #      start_date = string
    #      time       = string
    #    }))
    #    sql_server_audit_config = set(object({
    #      bucket             = string
    #      upload_interval    = string
    #      retention_interval = string
    #      time_zone          = string
    #    }))
    backup_configuration = set(object({
      binary_log_enabled             = bool
      enabled                        = bool
      start_time                     = string
      point_in_time_recovery_enabled = bool
      location                       = string
      transaction_log_retention_days = number
      backup_retention_settings      = set(object({
        retained_backups = number
        retention_unit   = string
      }))
    }))
    ip_configuration = set(object({
      ipv4_enabled        = bool
      private_network     = string
      require_ssl         = bool
      allocated_ip_range  = string
      authorized_networks = set(object({
        expiration_time = string
        name            = string
        value           = string
      }))
    }))
    location_preference = set(object({
      follow_gae_application = string
      zone                   = string
      #      secondary_zone         = string
    }))
    maintenance_window = set(object({
      day          = number
      hour         = number
      #  Receive updates earlier (canary) or later (stable)
      update_track = string
    }))
    insights_config = set(object({
      query_insights_enabled  = bool
      query_string_length     = number
      record_application_tags = bool
      record_client_address   = bool
      #      query_plans_per_minute  = number
    }))
    #    password_validation_policy = set(object({
    #      min_length                  = bool
    #      complexity                  = bool
    #      reuse_interval              = number
    #      disallow_username_substring = bool
    #      password_change_interval    = number
    #      enable_password_policy      = bool
    #    }))

  }))
  description = "The settings to use for the database. The configuration is detailed below"
  default     = []
}

variable "maintenance_version" {
  type        = string
  description = "The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored."
  default     = null
}

variable "master_instance_name" {
  type        = string
  description = "The name of the existing instance that will act as the master in the replication setup. Note, this requires the master to have binary_log_enabled set, as well as existing backups."
  default     = null
}

variable "replica_configuration" {
  type = set(object({
    ca_certificate            = string
    client_certificate        = string
    client_key                = string
    connect_retry_interval    = number
    dump_file_path            = string
    failover_target           = bool
    master_heartbeat_period   = number
    password                  = string
    sslCipher                 = string
    username                  = string
    verify_server_certificate = bool
  }))
  description = "The configuration for replication. The configuration is detailed below. Valid only for MySQL instances."
  default     = []
}

variable "encryption_key_name" {
  type        = string
  description = "The full path to the encryption key used for the CMEK disk encryption. Setting up disk encryption currently requires manual steps outside of Terraform. The provided key must be in the same region as the SQL instance. In order to use this feature, a special kind of service account must be created and granted permission on this key. This step can currently only be done manually, please see this step. That service account needs the Cloud KMS > Cloud KMS CryptoKey Encrypter/Decrypter role on your key - please see this step."
  default     = null
}

variable "deletion_protection" {
  type        = string
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply command that deletes the instance will fail. Defaults to true."
  default     = true
}

variable "restore_backup_context" {
  type = set(object({
    backup_run_id = string
    instance_id   = string
    project       = string
  }))
  description = "The context needed to restore the database to a backup run. This field will cause Terraform to trigger the database to restore from the backup run indicated. The configuration is detailed below. NOTE: Restoring from a backup is an imperative action and not recommended via Terraform. Adding or modifying this block during resource creation/update will trigger the restore action after the resource is created/updated."
  default     = []
}

variable "clone" {
  type = set(object({
    source_instance_name = string
    point_in_time        = string
    allocated_ip_range   = string
  }))
  description = "The context needed to create this instance as a clone of another instance. When this field is set during resource creation, Terraform will attempt to clone another instance as indicated in the context. The configuration is detailed below."
  default     = []
}

variable "database" {
  type = set(object({
    name            = string
    charset         = string
    collation       = string
    deletion_policy = string
  }))
  description = "Represents a SQL database inside the Cloud SQL instance, hosted in Google's cloud."
  default     = []
}

variable "users" {
  type      = set(object({
    name            = string
    password        = string
    # The user type. It determines the method to authenticate the user during login. The default is the database's built-in user type. Flags include "BUILT_IN", "CLOUD_IAM_USER", or "CLOUD_IAM_SERVICE_ACCOUNT".
    type            = string
    deletion_policy = string
    host            = string
    #    password_policy = set(object({
    #      allowed_failed_attempts      = number
    #      password_expiration_duration = number
    #      enable_failed_attempts_check = bool
    #      enable_password_verification = bool
    #      status                       = set(object({
    #        locked                   = bool
    #        password_expiration_time = number
    #      }))
    #    }))
  }))
}