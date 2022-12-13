data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.cluster_name

  # Additional
  kubernetes_version  = var.cluster_version
  node_resource_group = data.azurerm_resource_group.resource_group.name
  network_profile     = var.cluster_network_provider

  dynamic "default_node_pool" {
    for_each = var.node_pool
    content {
      name       = default_node_pool.value.name
      node_count = default_node_pool.value.node_count
      vm_size    = default_node_pool.value.vm_size

      dynamic "kubelet_config" {
        for_each = {for k, v in default_node_pool.value.kubelet_config : v => k}
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
    }
  }

  dynamic identity {
    for_each = var.identity
    content {
      type = identity.value.type
    }
  }

  dynamic "network_profile" {
    for_each = var.network
    content {
      network_plugin    = network_profile.value.network_plugin
      network_mode      = network_profile.value.network_mode
      network_policy    = network_profile.value.network_policy
      outbound_type     = network_profile.value.outbound_type
      load_balancer_sku = network_profile.value.load_balancer_sku

      dynamic load_balancer_profile {
        for_each = {for k, v in network_profile.value.load_balancer : v => k}
        content {
          idle_timeout_in_minutes  = load_balancer_profile.value.idle_timeout_in_minutes
          effective_outbound_ips   = load_balancer_profile.value.effective_outbound_ips
          outbound_ip_prefix_ids   = load_balancer_profile.value.outbound_ip_prefix_ids
          outbound_ports_allocated = load_balancer_profile.value.outbound_ports_allocated
        }
      }

      nat_gateway_profile {

      }
    }
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[*].node_count
    ]
  }
}