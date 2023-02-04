variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group"
}

variable "cluster_name" {
  type        = string
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "cluster_version" {
  type        = string
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). AKS does not require an exact patch version to be specified, minor version aliases such as 1.22 are also supported. - The minor version's latest GA patch is automatically chosen in that case."
  default     = "1.24"
}

variable "cluster_private_enabled" {
  type    = bool
  default = false
}

variable "cluster_mesh_enabled" {
  type    = bool
  default = false
}

variable "cluster_http_application_routing_enabled" {
  type        = bool
  description = "Http Routing"
  default     = false
}

variable "cluster_rbac" {
  type        = bool
  description = "Whether Role Based Access Control for the Kubernetes Cluster should be enabled."
  default     = true
}

variable "cluster_local_account_disabled" {
  type        = bool
  description = "If true local accounts will be disabled."
  default     = false
}

variable "cluster_run_command" {
  type        = bool
  description = "Whether to enable run command for the cluster or not."
  default     = true
}

variable "cluster_sku" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)."
  default     = "Free"
}

variable "cluster_kubelet" {
  type = set(object({
    client_id                 = string
    object_id                 = string
    user_assigned_identity_id = string
  }))
  default = []
}

variable "cluster_tags" {
  type    = map(any)
  default = {}
}

variable "ad_connector" {
  type = set(object({
    managed                = bool
    tenant_id              = string
    admin_group_object_ids = list(string)
    azure_rbac_enabled     = bool
  }))
  default = []
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
}

variable "scale" {
  type = set(object({
    balance_similar_node_groups      = bool
    # Expander to use. Possible values are least-waste, priority, most-pods and random
    expander                         = string
    max_graceful_termination_sec     = number
    max_node_provisioning_time       = string
    max_unready_nodes                = number
    max_unready_percentage           = number
    new_pod_scale_up_delay           = string
    scale_down_delay_after_add       = string
    scale_down_delay_after_delete    = string
    scale_down_delay_after_failure   = string
    scan_interval                    = string
    scale_down_unneeded              = string
    scale_down_unready               = string
    scale_down_utilization_threshold = number
    empty_bulk_delete_max            = number
    # If true cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath
    skip_nodes_with_local_storage    = bool
    # If true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods)
    skip_nodes_with_system_pods      = bool
  }))
  default = [
    {
      balance_similar_node_groups      = false
      expander                         = "random"
      max_graceful_termination_sec     = 600
      max_node_provisioning_time       = "15m"
      max_unready_nodes                = 3
      max_unready_percentage           = 45
      new_pod_scale_up_delay           = "10s"
      scale_down_delay_after_add       = "10m"
      scale_down_delay_after_delete    = "10s"
      scale_down_delay_after_failure   = "3m"
      scan_interval                    = "10s"
      scale_down_unneeded              = "10m"
      scale_down_unready               = "20m"
      scale_down_utilization_threshold = 0.5
      empty_bulk_delete_max            = 10
      skip_nodes_with_local_storage    = true
      skip_nodes_with_system_pods      = true
    }
  ]
}

variable "system_pool" {
  type = set(object({
    name                   = string
    vm_size                = string
    # capacity_reservation_group_id = string
    # custom_ca_trust_enabled = bool
    enable_auto_scaling    = bool
    max_count              = number
    min_count              = number
    node_count             = number
    # workload_runtime        = string
    zones                  = list(any)
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    kubelet                = set(object({
      allowed_unsafe_sysctls    = string
      container_log_max_line    = number
      container_log_max_size_mb = string
      cpu_cfs_quota_enabled     = bool
      cpu_cfs_quota_period      = string
      # Specifies the CPU Manager policy to use. Possible values are none and static
      cpu_manager_policy        = string
      image_gc_high_threshold   = number
      image_gc_low_threshold    = number
      pod_max_pid               = number
      # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node
      topology_manager_policy   = string
    }))
    linux = set(object({
      swap_file_size_mb = number
      sysctl_config     = set(object({
        fs_aio_max_nr                      = number
        fs_file_max                        = number
        fs_inotify_max_user_watches        = number
        fs_nr_open                         = number
        kernel_threads_max                 = number
        net_core_netdev_max_backlog        = number
        net_core_optmem_max                = number
        net_core_rmem_default              = number
        net_core_rmem_max                  = number
        net_core_somaxconn                 = number
        net_core_wmem_default              = number
        net_core_wmem_max                  = number
        net_ipv4_ip_local_port_range_max   = number
        net_ipv4_ip_local_port_range_min   = number
        net_ipv4_neigh_default_gc_thresh1  = number
        net_ipv4_neigh_default_gc_thresh2  = number
        net_ipv4_neigh_default_gc_thresh3  = number
        net_ipv4_tcp_fin_timeout           = number
        net_ipv4_tcp_keepalive_intvl       = number
        net_ipv4_tcp_keepalive_probes      = number
        net_ipv4_tcp_keepalive_time        = number
        net_ipv4_tcp_max_syn_backlog       = number
        net_ipv4_tcp_max_tw_buckets        = number
        net_ipv4_tcp_tw_reuse              = number
        net_netfilter_nf_conntrack_buckets = number
        net_netfilter_nf_conntrack_max     = number
        vm_max_map_count                   = number
        vm_swappiness                      = number
        vm_vfs_cache_pressure              = number
      }))
      # specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never
      transparent_huge_page_defrag  = string
      # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never
      transparent_huge_page_enabled = string
    }))
    fips_enabled                 = bool
    # The type of disk used by kubelet. Possible values are OS and Temporary
    kubelet_disk_type            = string
    max_pods                     = number
    node_labels                  = map(any)
    only_critical_addons_enabled = bool
    os_disk_size_gb              = number
    # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed
    os_disk_type                 = string
    # Specifies the OS SKU used by the agent pool. Possible values include: Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022
    os_sku                       = string
    pod_subnet_id                = string
    node_taints                  = list(any)
    # Specifies the autoscaling behaviour of the Kubernetes Cluster. If not specified, it defaults to 'ScaleDownModeDelete'. Possible values include 'ScaleDownModeDelete' and 'ScaleDownModeDeallocate'.
    # scale_down_mode              = string
    # The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets
    type                         = string
    tags                         = map(any)
    ultra_ssd_enabled            = bool
    upgrade_settings             = set(object({
      max_surge = string
    }))
    vnet_subnet_id = string
  }))
  default = [
    {
      name                         = "system"
      vm_size                      = "Standard_D2_v2"
      # custom_ca_trust_enabled      = false
      enable_auto_scaling          = true
      max_count                    = 1
      min_count                    = 1
      node_count                   = 0
      # workload_runtime             = "OCIContainer"
      zones                        = []
      enable_host_encryption       = false
      enable_node_public_ip        = false
      kubelet                      = []
      linux                        = []
      fips_enabled                 = false
      kubelet_disk_type            = "OS"
      max_pods                     = 110
      node_labels                  = {}
      only_critical_addons_enabled = false
      os_disk_size_gb              = 128
      os_disk_type                 = "Managed"
      os_sku                       = "Ubuntu"
      pod_subnet_id                = null
      # scale_down_mode              = "ScaleDownModeDelete"
      node_taints                  = []
      tags                         = {}
      ultra_ssd_enabled            = false
      upgrade_settings             = []
      vnet_subnet_id               = null
      type                         = "VirtualMachineScaleSets"
    }
  ]
}

variable "node_pool" {
  type = set(object({
    name                   = string
    vm_size                = string
    # capacity_reservation_group_id = string
    # custom_ca_trust_enabled = bool
    enable_auto_scaling    = bool
    max_count              = number
    min_count              = number
    node_count             = number
    # workload_runtime        = string
    zones                  = list(any)
    enable_host_encryption = bool
    enable_node_public_ip  = bool
    kubelet                = set(object({
      allowed_unsafe_sysctls    = string
      container_log_max_line    = number
      container_log_max_size_mb = string
      cpu_cfs_quota_enabled     = bool
      cpu_cfs_quota_period      = string
      # Specifies the CPU Manager policy to use. Possible values are none and static
      cpu_manager_policy        = string
      image_gc_high_threshold   = number
      image_gc_low_threshold    = number
      pod_max_pid               = number
      # Specifies the Topology Manager policy to use. Possible values are none, best-effort, restricted or single-numa-node
      topology_manager_policy   = string
    }))
    linux = set(object({
      swap_file_size_mb = number
      sysctl_config     = set(object({
        fs_aio_max_nr                      = number
        fs_file_max                        = number
        fs_inotify_max_user_watches        = number
        fs_nr_open                         = number
        kernel_threads_max                 = number
        net_core_netdev_max_backlog        = number
        net_core_optmem_max                = number
        net_core_rmem_default              = number
        net_core_rmem_max                  = number
        net_core_somaxconn                 = number
        net_core_wmem_default              = number
        net_core_wmem_max                  = number
        net_ipv4_ip_local_port_range_max   = number
        net_ipv4_ip_local_port_range_min   = number
        net_ipv4_neigh_default_gc_thresh1  = number
        net_ipv4_neigh_default_gc_thresh2  = number
        net_ipv4_neigh_default_gc_thresh3  = number
        net_ipv4_tcp_fin_timeout           = number
        net_ipv4_tcp_keepalive_intvl       = number
        net_ipv4_tcp_keepalive_probes      = number
        net_ipv4_tcp_keepalive_time        = number
        net_ipv4_tcp_max_syn_backlog       = number
        net_ipv4_tcp_max_tw_buckets        = number
        net_ipv4_tcp_tw_reuse              = number
        net_netfilter_nf_conntrack_buckets = number
        net_netfilter_nf_conntrack_max     = number
        vm_max_map_count                   = number
        vm_swappiness                      = number
        vm_vfs_cache_pressure              = number
      }))
      # specifies the defrag configuration for Transparent Huge Page. Possible values are always, defer, defer+madvise, madvise and never
      transparent_huge_page_defrag  = string
      # Specifies the Transparent Huge Page enabled configuration. Possible values are always, madvise and never
      transparent_huge_page_enabled = string
    }))
    fips_enabled      = bool
    # The type of disk used by kubelet. Possible values are OS and Temporary
    kubelet_disk_type = string
    max_pods          = number
    node_labels       = map(any)
    os_disk_size_gb   = number
    # The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed
    os_disk_type      = string
    # Specifies the OS SKU used by the agent pool. Possible values include: Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022
    os_sku            = string
    pod_subnet_id     = string
    node_taints       = list(any)
    # Specifies the autoscaling behaviour of the Kubernetes Cluster. If not specified, it defaults to 'ScaleDownModeDelete'. Possible values include 'ScaleDownModeDelete' and 'ScaleDownModeDeallocate'.
    # scale_down_mode              = string
    tags              = map(any)
    ultra_ssd_enabled = bool
    upgrade_settings  = set(object({
      max_surge = string
    }))
    vnet_subnet_id  = string
    #-------------------------------------------------------------------------------------------------------------------
    # Available only on Resources. Ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
    #-------------------------------------------------------------------------------------------------------------------
    # The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are Deallocate and Delete.
    # An Eviction Policy can only be configured when priority is set to Spot and will default to Delete unless otherwise specified.
    eviction_policy = string

    # The fully qualified resource ID of the Dedicated Host Group to provision virtual machines from.
    host_group_id  = string
    # Should this Node Pool be used for System or User resources? Possible values are System and User
    mode           = string
    # The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are Regular and Spot
    priority       = string
    # The maximum price you're willing to pay in USD per Virtual Machine. Valid values are -1 (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places. Changing this forces a new resource to be created.
    spot_max_price = number
    # The Operating System which should be used for this Node Pool. Changing this forces a new resource to be created. Possible values are Linux and Windows
    os_type        = string
  }))
  default = [
    {
      name                   = "system"
      vm_size                = "Standard_D2_v2"
      # custom_ca_trust_enabled      = false
      enable_auto_scaling    = true
      max_count              = 1
      min_count              = 1
      node_count             = 0
      # workload_runtime             = "OCIContainer"
      zones                  = []
      enable_host_encryption = false
      enable_node_public_ip  = false
      kubelet                = []
      linux                  = []
      fips_enabled           = false
      kubelet_disk_type      = "OS"
      max_pods               = 110
      node_labels            = {}
      os_disk_size_gb        = 128
      os_disk_type           = "Managed"
      os_sku                 = "Ubuntu"
      pod_subnet_id          = null
      # scale_down_mode              = "ScaleDownModeDelete"
      node_taints            = []
      tags                   = {}
      ultra_ssd_enabled      = false
      upgrade_settings       = []
      vnet_subnet_id         = null
      #-------------------------------------------------------------------------------------------------------------------
      # Available only on Resources. Ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool
      #-------------------------------------------------------------------------------------------------------------------
      eviction_policy        = "Delete"
      host_group_id          = null
      mode                   = "User"
      priority               = "Spot"
      spot_max_price         = -1
      os_type                = "Linux"
    }
  ]
}

variable "network" {
  type = set(object({
    dns_service_ip     = string
    docker_bridge_cidr = string
    service_cidr       = string
    # When network_plugin is set to azure - the vnet_subnet_id field in the default_node_pool block must be set and pod_cidr must not be set.
    network_plugin     = string
    network_policy     = string
    outbound_type      = string
    load_balancer_sku  = string
    load_balancer      = set(object({
      idle_timeout_in_minutes  = number
      outbound_ip_prefix_ids   = list(string)
      outbound_ports_allocated = number
    }))
    nat_gateway = set(object({
      idle_timeout_in_minutes   = number
      managed_outbound_ip_count = number
    }))
  }))
  default = [
    {
      dns_service_ip     = "10.1.0.10"
      docker_bridge_cidr = "172.17.0.1/16"
      service_cidr       = "10.1.0.0/16"
      network_plugin     = "azure"
      network_policy     = "azure"
      outbound_type      = "loadBalancer"
      load_balancer_sku  = "standard"
      load_balancer      = [
        {
          idle_timeout_in_minutes  = 30
          outbound_ip_prefix_ids   = []
          outbound_ports_allocated = 0
        }
      ]
      nat_gateway = []
    }
  ]
}

variable "network_connector" {
  type = set(object({
    subnet_name = string
  }))
  default = []
}

variable "ingress" {
  type = set(object({
    gateway_id   = string
    gateway_name = string
    subnet_cidr  = string
    subnet_id    = string
  }))
  default = []
}

variable "proxy" {
  type = set(object({
    http_proxy  = string
    https_proxy = string
    no_proxy    = list(string)
  }))
  default = []
}

variable "vault" {
  type = set(object({
    secret_rotation_enabled  = bool
    secret_rotation_interval = string
  }))
  default = []
}

variable "storage" {
  type = set(object({
    blob_driver_enabled         = bool
    disk_driver_enabled         = bool
    disk_driver_version         = string
    file_driver_enabled         = bool
    snapshot_controller_enabled = bool
  }))
  default = [
    {
      blob_driver_enabled         = false
      disk_driver_enabled         = true
      disk_driver_version         = "v1"
      file_driver_enabled         = true
      snapshot_controller_enabled = true
    }
  ]
}

variable "identity" {
  type = set(object({
    type         = string
    identity_ids = list(string)
  }))
  default = [
    {
      type         = "SystemAssigned"
      identity_ids = []
    }
  ]
}

variable "windows" {
  type = set(object({
    admin_username = string
    admin_password = string
    license        = string
  }))
  default = []
}
