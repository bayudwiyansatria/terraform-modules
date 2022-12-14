data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                              = var.cluster_name
  location                          = data.azurerm_resource_group.resource_group.location
  resource_group_name               = data.azurerm_resource_group.resource_group.name
  dns_prefix                        = var.cluster_name
  kubernetes_version                = var.cluster_version
  node_resource_group               = "aks-${data.azurerm_resource_group.resource_group.name}RG-${var.cluster_name}"
  role_based_access_control_enabled = var.cluster_rbac
  # run_command_enabled               = var.cluster_run_command
  private_cluster_enabled           = var.cluster_private_enabled
  tags                              = var.cluster_tags

  dynamic "aci_connector_linux" {
    for_each = var.network_connector
    content {
      subnet_name = aci_connector_linux.value.subnet_name
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.scale
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                         = auto_scaler_profile.value.expander
      max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                    = auto_scaler_profile.value.scan_interval
      scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready               = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.ad_connector
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = var.system_pool
    content {
      name                   = default_node_pool.value.name
      vm_size                = default_node_pool.value.vm_size
      # custom_ca_trust_enabled = default_node_pool.value.custom_ca_trust_enabled
      enable_auto_scaling    = default_node_pool.value.node_count > 0 ? false : default_node_pool.value.enable_auto_scaling
      max_count              = default_node_pool.value.enable_auto_scaling == true ? default_node_pool.value.max_count : null
      min_count              = default_node_pool.value.enable_auto_scaling == true ? default_node_pool.value.min_count : null
      node_count             = default_node_pool.value.enable_auto_scaling == true ? 1 : default_node_pool.value.node_count
      # workload_runtime        = default_node_pool.value.enable_auto_scaling == true ? null : default_node_pool.value.workload_runtime
      zones                  = default_node_pool.value.enable_auto_scaling == true ? [] : default_node_pool.value.zones
      enable_host_encryption = default_node_pool.value.enable_host_encryption
      enable_node_public_ip  = default_node_pool.value.enable_node_public_ip

      dynamic "kubelet_config" {
        for_each = toset(default_node_pool.value.kubelet)
        content {
          allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
          container_log_max_line    = kubelet_config.value.container_log_max_line
          container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
          cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
          cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
          cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
          image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
          image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
          pod_max_pid               = kubelet_config.value.pod_max_pid
          topology_manager_policy   = kubelet_config.value.topology_manager_policy
        }
      }

      dynamic "linux_os_config" {
        for_each = toset(default_node_pool.value.linux)
        content {
          swap_file_size_mb = linux_os_config.value.swap_file_size_mb

          dynamic "sysctl_config" {
            for_each = toset(linux_os_config.value.sysctl_config)
            content {
              fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
              fs_file_max                        = sysctl_config.value.fs_file_max
              fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
              fs_nr_open                         = sysctl_config.value.fs_nr_open
              kernel_threads_max                 = sysctl_config.value.kernel_threads_max
              net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
              net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
              net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
              net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
              net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
              net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
              net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
              net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
              net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
              net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
              net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
              net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
              net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
              net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
              net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
              net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
              net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
              net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
              net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
              net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
              net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
              vm_max_map_count                   = sysctl_config.value.vm_max_map_count
              vm_swappiness                      = sysctl_config.value.vm_swappiness
              vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
            }
          }
          transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
          transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled
        }
      }
      fips_enabled                 = default_node_pool.value.fips_enabled
      kubelet_disk_type            = default_node_pool.value.kubelet_disk_type
      max_pods                     = default_node_pool.value.max_pods
      node_labels                  = default_node_pool.value.node_labels
      only_critical_addons_enabled = default_node_pool.value.only_critical_addons_enabled
      os_disk_size_gb              = default_node_pool.value.os_disk_size_gb
      os_disk_type                 = default_node_pool.value.os_disk_type
      os_sku                       = default_node_pool.value.os_sku
      pod_subnet_id                = default_node_pool.value.pod_subnet_id
      node_taints                  = default_node_pool.value.node_taints
      # scale_down_mode              = default_node_pool.value.scale_down_mode
      type                         = default_node_pool.value.type
      tags                         = default_node_pool.value.tags
      ultra_ssd_enabled            = default_node_pool.value.ultra_ssd_enabled

      dynamic "upgrade_settings" {
        for_each = toset(default_node_pool.value.upgrade_settings)
        content {
          max_surge = upgrade_settings.value.max_surge
        }
      }

      vnet_subnet_id = default_node_pool.value.vnet_subnet_id == null ? null : default_node_pool.value.vnet_subnet_id
    }
  }


  dynamic identity {
    for_each = var.identity
    content {
      type = identity.value.type
    }
  }

  #  dynamic "service_principal" {
  #    for_each = ""
  #    content {
  #
  #    }
  #  }

  #  dynamic "ingress_application_gateway" {
  #    for_each = ""
  #    content {}
  #  }

  dynamic "kubelet_identity" {
    for_each = var.cluster_kubelet
    content {
      client_id                 = kubelet_identity.value.client_id
      object_id                 = kubelet_identity.value.object_id
      user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
    }
  }
  dynamic "network_profile" {
    for_each = var.network
    content {
      dns_service_ip     = network_profile.value.dns_service_ip
      docker_bridge_cidr = network_profile.value.docker_bridge_cidr
      service_cidr       = network_profile.value.service_cidr
      network_plugin     = network_profile.value.network_plugin
      network_policy     = network_profile.value.network_policy
      outbound_type      = network_profile.value.outbound_type
      load_balancer_sku  = network_profile.value.load_balancer_sku

      dynamic load_balancer_profile {
        for_each = toset(network_profile.value.load_balancer)
        content {
          idle_timeout_in_minutes  = load_balancer_profile.value.idle_timeout_in_minutes
          outbound_ip_prefix_ids   = load_balancer_profile.value.outbound_ip_prefix_ids
          outbound_ports_allocated = load_balancer_profile.value.outbound_ports_allocated
        }
      }

      dynamic "nat_gateway_profile" {
        for_each = toset(network_profile.value.nat_gateway)
        content {
          idle_timeout_in_minutes   = nat_gateway_profile.value.idle_timeout_in_minutes
          managed_outbound_ip_count = nat_gateway_profile.value.managed_outbound_ip_count
        }
      }
    }
  }

  dynamic "http_proxy_config" {
    for_each = var.proxy
    content {
      http_proxy  = http_proxy_config.value.http_proxy
      https_proxy = http_proxy_config.value.https_proxy
      no_proxy    = http_proxy_config.value.no_proxy
    }
  }

  dynamic "windows_profile" {
    for_each = var.windows
    content {
      admin_username = windows_profile.value.admin_username
      admin_password = windows_profile.value.admin_password
      license        = windows_profile.value.license
    }
  }

  #  dynamic "lifecycle" {
  #    for_each = ""
  #    content {}
  #  }

}

resource "azurerm_kubernetes_cluster_node_pool" "pool" {
  for_each               = {for k, v in var.node_pool : v.name => k}
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.cluster.id
  name                   = each.value.name
  vm_size                = each.value.vm_size
  # custom_ca_trust_enabled = each.value.custom_ca_trust_enabled
  enable_auto_scaling    = each.value.node_count > 0 ? false : each.value.enable_auto_scaling
  max_count              = each.value.enable_auto_scaling == true ? each.value.max_count : null
  min_count              = each.value.enable_auto_scaling == true ? each.value.min_count : null
  node_count             = each.value.enable_auto_scaling == true ? 1 : each.value.node_count
  # workload_runtime        = each.value.enable_auto_scaling == true ? null : each.value.workload_runtime
  zones                  = each.value.enable_auto_scaling == true ? [] : each.value.zones
  enable_host_encryption = each.value.enable_host_encryption
  enable_node_public_ip  = each.value.enable_node_public_ip

  dynamic "kubelet_config" {
    for_each = toset(each.value.kubelet)
    content {
      allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
      container_log_max_line    = kubelet_config.value.container_log_max_line
      container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
      cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
      cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
      image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
      image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
      pod_max_pid               = kubelet_config.value.pod_max_pid
      topology_manager_policy   = kubelet_config.value.topology_manager_policy
    }
  }

  dynamic "linux_os_config" {
    for_each = toset(each.value.linux)
    content {
      swap_file_size_mb = linux_os_config.value.swap_file_size_mb

      dynamic "sysctl_config" {
        for_each = toset(linux_os_config.value.sysctl_config)
        content {
          fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
          fs_file_max                        = sysctl_config.value.fs_file_max
          fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
          fs_nr_open                         = sysctl_config.value.fs_nr_open
          kernel_threads_max                 = sysctl_config.value.kernel_threads_max
          net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
          net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
          net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
          net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
          net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
          net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
          net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
          net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
          net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
          net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
          net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
          net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
          net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
          net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
          net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
          net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
          net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
          net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
          net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
          vm_max_map_count                   = sysctl_config.value.vm_max_map_count
          vm_swappiness                      = sysctl_config.value.vm_swappiness
          vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
        }
      }
      transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
      transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled
    }
  }
  fips_enabled      = each.value.fips_enabled
  kubelet_disk_type = each.value.kubelet_disk_type
  max_pods          = each.value.max_pods
  node_labels       = each.value.node_labels
  os_disk_size_gb   = each.value.os_disk_size_gb
  os_disk_type      = each.value.os_disk_type
  os_sku            = each.value.os_sku
  pod_subnet_id     = each.value.pod_subnet_id
  node_taints       = each.value.node_taints
  # scale_down_mode = each.value.scale_down_mode
  tags              = each.value.tags
  ultra_ssd_enabled = each.value.ultra_ssd_enabled

  dynamic "upgrade_settings" {
    for_each = toset(each.value.upgrade_settings)
    content {
      max_surge = upgrade_settings.value.max_surge
    }
  }

  vnet_subnet_id = each.value.vnet_subnet_id == null ? null : each.value.vnet_subnet_id

  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}