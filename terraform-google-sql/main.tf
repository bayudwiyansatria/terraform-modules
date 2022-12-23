locals {
  sql = length(regexall("MySQL_([0-9]+)", var.database_version)) > 0 ? true : false
}

resource "google_sql_database_instance" "instance" {
  region               = var.region
  database_version     = var.database_version
  name                 = var.name
  master_instance_name = var.master_instance_name
  project              = var.project
  root_password        = local.sql ? var.root_password : var.root_password
  deletion_protection  = var.deletion_protection

  dynamic "settings" {
    for_each = var.settings
    content {
      tier                  = settings.value.tier
      activation_policy     = settings.value.activation_policy
      availability_type     = settings.value.availability_type
      collation             = settings.value.collation
      disk_autoresize       = settings.value.disk_autoresize
      disk_autoresize_limit = settings.value.disk_autoresize_limit
      disk_type             = settings.value.disk_type
      disk_size             = settings.value.disk_size
      pricing_plan          = settings.value.pricing_plan
      user_labels           = settings.value.user_labels

      dynamic "database_flags" {
        for_each = {
          for k, v in settings.value.database_flags : v.name => k
        }
        content {
          name  = database_flags.value.name
          value = database_flags.value.value
        }
      }

      dynamic "active_directory_config" {
        for_each = settings.value.active_directory_config
        content {
          domain = active_directory_config.value.domain
        }
      }

      dynamic "backup_configuration" {
        for_each = settings.value.backup_configuration
        content {
          binary_log_enabled             = backup_configuration.value.binary_log_enabled
          enabled                        = backup_configuration.value.enabled
          start_time                     = backup_configuration.value.start_time
          location                       = backup_configuration.value.location
          transaction_log_retention_days = backup_configuration.value.transaction_log_retention_days
          point_in_time_recovery_enabled = length(regexall("MySQL_([0-9]+)", var.database_version)) > 0 ? null : backup_configuration.value.point_in_time_recovery_enabled
          dynamic "backup_retention_settings" {
            for_each = backup_configuration.value.backup_retention_settings
            content {
              retained_backups = backup_retention_settings.value.retained_backups
              retention_unit   = backup_retention_settings.value.retention_unit
            }
          }
        }
      }

      dynamic "ip_configuration" {
        for_each = settings.value.ip_configuration
        content {
          ipv4_enabled       = ip_configuration.value.ipv4_enabled
          private_network    = ip_configuration.value.private_network
          require_ssl        = ip_configuration.value.require_ssl
          allocated_ip_range = ip_configuration.value.allocated_ip_range

          dynamic "authorized_networks" {
            for_each = {
              for k, v in ip_configuration.value.authorized_networks : v.name => k
            }
            content {
              name            = authorized_networks.value.name
              value           = authorized_networks.value.value
              expiration_time = authorized_networks.value.expiration_time
            }
          }
        }
      }

      dynamic "location_preference" {
        for_each = settings.value.location_preference
        content {
          follow_gae_application = location_preference.value.follow_gae_application
          zone                   = location_preference.value.zone
        }
      }

      dynamic "maintenance_window" {
        for_each = settings.value.maintenance_window
        content {
          day          = maintenance_window.value.day
          hour         = maintenance_window.value.hour
          update_track = maintenance_window.value.update_track
        }
      }

      dynamic "insights_config" {
        for_each = settings.value.insights_config
        content {
          query_insights_enabled  = insights_config.value.query_insights_enabled
          query_string_length     = insights_config.value.query_string_length
          record_application_tags = insights_config.value.record_application_tags
          record_client_address   = insights_config.value.record_client_address
        }
      }
    }
  }

  dynamic "replica_configuration" {
    for_each = toset(length(regexall("MySQL_([0-9]+)", var.database_version)) > 0 ? var.replica_configuration : [])
    content {
      ca_certificate            = replica_configuration.value.ca_certificate
      client_certificate        = replica_configuration.value.client_certificate
      client_key                = replica_configuration.value.client_key
      connect_retry_interval    = replica_configuration.value.connect_retry_interval
      dump_file_path            = replica_configuration.value.dump_file_path
      failover_target           = replica_configuration.value.failover_target
      master_heartbeat_period   = replica_configuration.value.master_heartbeat_period
      password                  = replica_configuration.value.password
      ssl_cipher                = replica_configuration.value.ssl_cipher
      username                  = replica_configuration.value.username
      verify_server_certificate = replica_configuration.value.verify_server_certificate
    }
  }

  dynamic "restore_backup_context" {
    for_each = var.restore_backup_context
    content {
      backup_run_id = restore_backup_context.value.backup_run_id
      instance_id   = restore_backup_context.value.instance_id
      project       = restore_backup_context.value.project
    }
  }

  dynamic "clone" {
    for_each = var.clone
    content {
      source_instance_name = clone.value.source_instance_name
      point_in_time        = clone.value.point_in_time
      allocated_ip_range   = clone.value.allocated_ip_range
    }
  }
}

resource "google_sql_database" "database" {
  for_each = {
    for k, v in toset(var.database) : v.name => k
  }
  name            = each.value.name
  instance        = google_sql_database_instance.instance.name
  charset         = each.value.charset
  collation       = each.value.collation
  project         = google_sql_database_instance.instance.project
  deletion_policy = each.value.deletion_policy

  depends_on = [
    google_sql_database_instance.instance
  ]
}

resource "google_sql_user" "users" {
  for_each = {
    for k, v in toset(var.users) : v.name => k
  }
  instance        = google_sql_database_instance.instance.name
  name            = each.value.name
  password        = each.value.password
  type            = each.value.type
  deletion_policy = each.value.deletion_policy
  host            = each.value.host
  project         = google_sql_database_instance.instance.project

  depends_on = [
    google_sql_database.database,
    google_sql_database_instance.instance
  ]
}