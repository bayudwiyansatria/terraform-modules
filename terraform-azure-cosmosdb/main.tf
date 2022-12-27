data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  ip_filter = length(var.ip_range_filter) > 0 ? join(", ", [for s in var.ip_range_filter : format("%q", s)]) : null
}

resource "azurerm_cosmosdb_account" "mongo" {
  name                                  = var.name
  resource_group_name                   = data.azurerm_resource_group.resource_group.name
  location                              = data.azurerm_resource_group.resource_group.location
  tags                                  = var.tags
  offer_type                            = var.offer_type
  create_mode                           = length(var.backup) > 0 ? var.backup.0.type == "Continuous" ? var.create_mode : null : null
  default_identity_type                 = var.default_identity_type
  kind                                  = var.kind
  ip_range_filter                       = local.ip_filter
  enable_free_tier                      = var.enable_free_tier
  analytical_storage_enabled            = var.analytical_storage_enabled
  enable_automatic_failover             = var.enable_automatic_failover
  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.is_virtual_network_filter_enabled
  key_vault_key_id                      = var.key_vault_key_id
  enable_multiple_write_locations       = var.enable_multiple_write_locations
  access_key_metadata_writes_enabled    = var.access_key_metadata_writes_enabled
  mongo_server_version                  = var.mongo_server_version
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids
  local_authentication_disabled         = var.local_authentication_disabled


  dynamic "analytical_storage" {
    for_each = var.analytical_storage
    content {
      schema_type = analytical_storage.value
    }
  }

  dynamic "capacity" {
    for_each = var.capacity
    content {
      total_throughput_limit = capacity.value
    }
  }

  dynamic "consistency_policy" {
    for_each = var.consistency_policy
    content {
      consistency_level       = consistency_policy.value.consistency_level
      max_interval_in_seconds = consistency_policy.value.max_interval_in_seconds
      max_staleness_prefix    = consistency_policy.value.max_staleness_prefix
    }
  }

  dynamic "geo_location" {
    for_each = var.geo_location
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities
    content {
      name = capabilities.value
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.backup
    content {
      type                = backup.value.type
      interval_in_minutes = backup.value.interval_in_minutes
      retention_in_hours  = backup.value.retention_in_hours
      storage_redundancy  = backup.value.storage_redundancy
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule
    content {
      allowed_headers    = cors_rule.value.allowed_headers
      allowed_methods    = cors_rule.value.allowed_methods
      allowed_origins    = cors_rule.value.allowed_origins
      exposed_headers    = cors_rule.value.exposed_headers
      max_age_in_seconds = cors_rule.value.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = length(identity.value.identity_ids) > 0 ? identity.value.identity_ids : []
    }
  }

  dynamic "restore" {
    for_each = var.create_mode == "Restore" ? var.restore : []
    content {
      source_cosmosdb_account_id = restore.value.source_cosmosdb_account_id
      restore_timestamp_in_utc   = restore.value.restore_timestamp_in_utc

      dynamic "database" {
        for_each = restore.value.database
        content {
          name             = database.value.name
          collection_names = database.value.collection_names
        }
      }
    }
  }

}
