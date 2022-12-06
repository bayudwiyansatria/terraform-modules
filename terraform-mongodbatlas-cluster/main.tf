locals {
  projects = flatten([
    for project in data.mongodbatlas_project.project.* : [
      for k, v in project : {
        id   = k
        name = v.name
      }
    ]
  ])
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  for_each = {
    for tuple in setproduct(var.clusters, local.projects) : "${tuple[1].name}-${tuple[0].name}"
    => {
      project_id = tuple[1].id
      name       = tuple[0].name
      size       = tuple[0].size
      type       = tuple[0].type
    }
  }
  project_id     = each.value.project_id
  name           = each.value.name
  cluster_type   = each.value.type
  backup_enabled = var.enable_backup
  pit_enabled    = false

  replication_specs {
    num_shards = 1
    dynamic region_configs {
      for_each = var.region_configs
      content {

        dynamic electable_specs {
          for_each = var.node_specs
          content {
            instance_size = electable_specs.value.instance_size
          }
        }

        dynamic analytics_specs {
          for_each = {
            for k, v in var.node_specs :
            k => v
            if !contains(["M0", "M2", "M5"], v.instance_size)
          }
          content {
            instance_size = analytics_specs.value.instance_size
          }
        }

        dynamic read_only_specs {
          for_each = {
            for k, v in var.node_specs :
            k => v
            if !contains(["M0", "M2", "M5"], v.instance_size)
          }
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