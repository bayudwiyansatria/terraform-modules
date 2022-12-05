resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id     = var.project_id
  name           = var.name
  cluster_type   = var.type
  backup_enabled = var.enable_backup
  pit_enabled    = false

  replication_specs {
    num_shards = 1
    dynamic region_configs {
      for_each = var.region_configs
      content {

        dynamic auto_scaling {
          for_each = var.auto_scaling_specs
          content {
            compute_enabled            = auto_scaling.value.compute_enabled
            disk_gb_enabled            = auto_scaling.value.disk_gb_enabled
            compute_scale_down_enabled = auto_scaling.value.compute_scale_down_enabled
            compute_min_instance_size  = auto_scaling.value.compute_min_instance_size
            compute_max_instance_size  = auto_scaling.value.compute_max_instance_size
          }
        }

        dynamic electable_specs {
          for_each = var.node_specs
          content {
            instance_size = electable_specs.value.instance_size
          }
        }

        dynamic analytics_specs {
          for_each = var.node_specs
          content {
            instance_size = analytics_specs.value.instance_size
          }
        }

        dynamic read_only_specs {
          for_each = var.node_specs
          content {
            instance_size = read_only_specs.value.instance_size
          }
        }
        backing_provider_name = region_configs.value.backing_provider_name
        priority              = region_configs.value.priority
        provider_name         = region_configs.value.provider_name
        region_name           = region_configs.value.region_name
      }
    }
  }
}