resource "google_container_cluster" "cluster" {
  name                      = var.name
  location                  = var.location
  node_locations            = var.node_locations
  #  cluster_ipv4_cidr         = var.cluster_ipv4_cidr
  description               = var.description
  default_max_pods_per_node = var.default_max_pods_per_node
  enable_kubernetes_alpha   = var.enable_kubernetes_alpha
  enable_tpu                = var.enable_tpu
  enable_legacy_abac        = var.enable_legacy_abac
  enable_shielded_nodes     = var.enable_shielded_nodes
  #  enable_autopilot        = var.enable_autopilot
  initial_node_count        = var.initial_node_count
  networking_mode           = var.networking_mode
  min_master_version        = var.min_master_version
  monitoring_service        = var.monitoring_service
  network                   = var.network
  node_version              = var.node_version
  project                   = var.project
  remove_default_node_pool  = var.remove_default_node_pool
  resource_labels           = var.resource_labels
  subnetwork                = var.subnetwork
  #  enable_intranode_visibility = var.enable_intranode_visibility
  #  enable_l4_ilb_subsetting    = var.enable_l4_ilb_subsetting
  datapath_provider         = var.datapath_provider


  dynamic "addons_config" {
    for_each = var.addons_config
    content {

      dynamic "horizontal_pod_autoscaling" {
        for_each = addons_config.value.horizontal_pod_autoscaling
        content {
          disabled = horizontal_pod_autoscaling.value.disabled
        }
      }

      dynamic "http_load_balancing" {
        for_each = addons_config.value.http_load_balancing
        content {
          disabled = http_load_balancing.value.disabled
        }
      }

      dynamic "network_policy_config" {
        for_each = addons_config.value.network_policy_config
        content {
          disabled = network_policy_config.value.disabled
        }
      }

      dynamic "gcp_filestore_csi_driver_config" {
        for_each = addons_config.value.gcp_filestore_csi_driver_config
        content {
          enabled = gcp_filestore_csi_driver_config.value.enabled
        }
      }

      dynamic "cloudrun_config" {
        for_each = addons_config.value.cloudrun_config
        content {
          disabled           = cloudrun_config.value.disabled
          load_balancer_type = cloudrun_config.value.load_balancer_type
        }
      }

      #      dynamic "istio_config" {
      #        for_each = addons_config.value.istio_config
      #        content {
      #          disabled = istio_config.value.disabled
      #
      #        }
      #      }

      #      dynamic "identity_service_config" {
      #        for_each = addons_config.value.identity_service_config
      #        content {
      #          enabled = identity_service_config.value.enabled
      #        }
      #      }

      #      dynamic "dns_cache_config" {
      #        for_each = addons_config.value.dns_cache_config
      #        content {
      #          enabled = dns_cache_config.value.enabled
      #        }
      #      }

      #      dynamic "gce_persistent_disk_csi_driver_config" {
      #        for_each = addons_config.value.gce_persistent_disk_csi_driver_config
      #        content {
      #          enabled = gce_persistent_disk_csi_driver_config.value.enabled
      #        }
      #      }

      #      dynamic "kalm_config" {
      #        for_each = addons_config.value.kalm_config
      #        content {
      #          enabled = kalm_config.value.enabled
      #        }
      #      }
      #

      #      dynamic "config_connector_config" {
      #        for_each = addons_config.value.config_connector_config
      #        content {
      #          enabled = config_connector_config.value.enabled
      #        }
      #      }

      #      dynamic "gke_backup_agent_config" {
      #        for_each = addons_config.value.gke_backup_agent_config
      #        content {
      #          enabled = gke_backup_agent_config.value.enabled
      #        }
      #      }
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling
    content {
      enabled = cluster_autoscaling.value.enabled

      dynamic "resource_limits" {
        for_each = cluster_autoscaling.value.resource_limits
        content {
          resource_type = resource_limits.value.resource_type
          minimum       = resource_limits.value.minimum
          maximum       = resource_limits.value.maximum
        }
      }

      #      dynamic "auto_provisioning_defaults" {
      #        for_each = cluster_autoscaling.value.auto_provisioning_defaults
      #        content {
      #          oauth_scopes    = auto_provisioning_defaults.value.oauth_scopes
      #          service_account = auto_provisioning_defaults.value.service_account
      #          image_type      = auto_provisioning_defaults.value.image_type
      #
      #          dynamic "shielded_instance_config" {
      #            for_each = auto_provisioning_defaults.value.shielded_instance_config
      #            content {
      #              enable_secure_boot = shielded_instance_config.value.enable_secure_boot
      #            }
      #          }
      #
      #          dynamic "management" {
      #            for_each = auto_provisioning_defaults.value.management
      #            content {
      #              auto_upgrade = management.value.auto_upgrade
      #              auto_repair  = management.value.auto_repair
      #            }
      #          }
      #        }
      #      }
    }
  }

  dynamic "database_encryption" {
    for_each = var.database_encryption
    content {
      state    = database_encryption.value.state
      key_name = database_encryption.value.key_name
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy
    content {
      #      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      #      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
      cluster_ipv4_cidr_block  = ip_allocation_policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block = ip_allocation_policy.value.services_ipv4_cidr_block
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config
    content {
      enable_components = logging_config.value.enable_components
    }
  }

  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy
    content {

      dynamic "daily_maintenance_window" {
        for_each = maintenance_policy.value.daily_maintenance_window
        content {
          start_time = daily_maintenance_window.value.start_time
        }
      }

      dynamic "recurring_window" {
        for_each = maintenance_policy.value.recurring_window
        content {
          start_time = recurring_window.value.start_time
          end_time   = recurring_window.value.end_time
          recurrence = recurring_window.value.recurrence
        }
      }

      dynamic "maintenance_exclusion" {
        for_each = maintenance_policy.value.maintenance_exclusion
        content {
          exclusion_name = maintenance_exclusion.value.exclusion_name
          start_time     = maintenance_exclusion.value.start_time
          end_time       = maintenance_exclusion.value.end_time
        }
      }
    }
  }

  dynamic "master_auth" {
    for_each = var.master_auth
    content {

      dynamic "client_certificate_config" {
        for_each = master_auth.value.client_certificate_config
        content {
          issue_client_certificate = client_certificate_config.value.issue_client_certificate
        }
      }
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = var.master_authorized_networks_config
    content {

      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          display_name = cidr_blocks.value.display_name
          cidr_block   = cidr_blocks.value.cidr_block
        }
      }
    }
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_config
    content {
      enable_components = monitoring_config.value.enable_components
    }
  }

  dynamic "network_policy" {
    for_each = var.network_policy
    content {
      provider = network_policy.value.provider
      enabled  = network_policy.value.enabled
    }
  }

  #  dynamic "node_config" {
  #    for_each = var.node_config
  #    content {
  #      disk_size_gb = number
  #      disk_type    = string
  #
  #      dynamic "gcfs_config" {
  #        for_each = node_config.value.gcfs_config
  #        content {
  #          enabled = gcfs_config.value.enabled
  #        }
  #      }
  #
  #      dynamic "gvnic" {
  #        for_each = node_config.value.gvnic
  #        content {
  #          enabled = gvnic.value.enabled
  #        }
  #      }
  #
  #
  #      dynamic "guest_accelerator" {
  #        for_each = node_config.value.guest_accelerator
  #        content {
  #          type               = guest_accelerator.value.type
  #          count              = guest_accelerator.value.count
  #          gpu_partition_size = guest_accelerator.value.gpu_partition_size
  #        }
  #      }
  #
  #      image_type        = node_config.value.image_type
  #      labels            = node_config.value.labels
  #      local_ssd_count   = node_config.value.local_ssd_count
  #      machine_type      = node_config.value.machine_type
  #      metadata          = node_config.value.metadata
  #      min_cpu_platform  = node_config.value.min_cpu_platform
  #      oauth_scopes      = node_config.value.oauth_scopes
  #      preemptible       = node_config.value.preemptible
  #      spot              = node_config.value.preemptible.spot
  #      boot_disk_kms_key = node_config.value.boot_disk_kms_key
  #      service_account   = node_config.value.service_account
  #
  #      dynamic "shielded_instance_config" {
  #        for_each = node_config.value.shielded_instance_config
  #        content {
  #          enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
  #          enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
  #        }
  #      }
  #
  #      tags = node_config.value.tags
  #
  #      dynamic "taint" {
  #        for_each = node_config.value.taint
  #        content {
  #          key    = taint.value.key
  #          value  = taint.value.value
  #          effect = taint.value.effect
  #        }
  #      }
  #
  #      dynamic "workload_metadata_config" {
  #        for_each = node_config.value.workload_metadata_config
  #        content {
  #          mode = workload_metadata_config.value.mode
  #        }
  #      }
  #
  #      node_group = node_config.value.node_group
  #    }
  #  }

  #  node_pool {}

  dynamic "confidential_nodes" {
    for_each = var.confidential_nodes
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  dynamic "authenticator_groups_config" {
    for_each = var.authenticator_groups_config
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config
    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
    }
  }

  dynamic "release_channel" {
    for_each = var.release_channel
    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_config
    content {

      dynamic "bigquery_destination" {
        for_each = resource_usage_export_config.value.bigquery_destination
        content {
          dataset_id = bigquery_destination.value.dataset_id
        }
      }

    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.vertical_pod_autoscaling
    content {
      enabled = vertical_pod_autoscaling.value.enabled
    }
  }

  #  dynamic "workload_identity_config" {
  #    for_each = var.workload_identity_config
  #    content {
  #
  #    }
  #  }

  dynamic "default_snat_status" {
    for_each = var.default_snat_status
    content {
      disabled = default_snat_status.value.disabled
    }
  }

  dynamic "dns_config" {
    for_each = var.dns_config
    content {
      cluster_dns        = dns_config.value.cluster_dns
      cluster_dns_scope  = dns_config.value.cluster_dns_scope
      cluster_dns_domain = dns_config.value.cluster_dns_domain
    }
  }

}

resource "google_container_node_pool" "nodes" {
  name       = var.name
  cluster    = google_container_cluster.cluster.id
  node_count = 1

  dynamic "node_config" {
    for_each = var.node_config
    content {
      disk_size_gb = number
      disk_type    = string

      dynamic "gcfs_config" {
        for_each = node_config.value.gcfs_config
        content {
          enabled = gcfs_config.value.enabled
        }
      }

      dynamic "gvnic" {
        for_each = node_config.value.gvnic
        content {
          enabled = gvnic.value.enabled
        }
      }


      dynamic "guest_accelerator" {
        for_each = node_config.value.guest_accelerator
        content {
          type               = guest_accelerator.value.type
          count              = guest_accelerator.value.count
          gpu_partition_size = guest_accelerator.value.gpu_partition_size
        }
      }

      image_type        = node_config.value.image_type
      labels            = node_config.value.labels
      local_ssd_count   = node_config.value.local_ssd_count
      machine_type      = node_config.value.machine_type
      metadata          = node_config.value.metadata
      min_cpu_platform  = node_config.value.min_cpu_platform
      oauth_scopes      = node_config.value.oauth_scopes
      preemptible       = node_config.value.preemptible
      spot              = node_config.value.preemptible.spot
      boot_disk_kms_key = node_config.value.boot_disk_kms_key
      #      service_account   = node_config.value.service_account

      dynamic "shielded_instance_config" {
        for_each = node_config.value.shielded_instance_config
        content {
          enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
          enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
        }
      }

      tags = node_config.value.tags

      dynamic "taint" {
        for_each = node_config.value.taint
        content {
          key    = taint.value.key
          value  = taint.value.value
          effect = taint.value.effect
        }
      }

      dynamic "workload_metadata_config" {
        for_each = node_config.value.workload_metadata_config
        content {
          mode = workload_metadata_config.value.mode
        }
      }

      node_group = node_config.value.node_group
    }
  }

  depends_on = [
    google_container_cluster.cluster
  ]
}