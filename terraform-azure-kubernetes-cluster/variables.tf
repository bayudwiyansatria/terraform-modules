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

variable "cluster_network_provider" {
  type        = string
  description = "If network_profile is not defined, kubenet profile will be used by default."
  default     = "network_profile"
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
}


variable "node_pool" {
  type = set(object({
    name                   = string
    vm_size                = string
    enable_auto_scaling    = bool
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
  }))
  default = [
    {
      name                   = "default"
      vm_size                = "Standard_D2_v2"
      enable_auto_scaling    = false
      enable_host_encryption = false
      enable_node_public_ip  = false
      kubelet                = []
    }
  ]
}

variable "network" {
  type = set(object({
    # When network_plugin is set to azure - the vnet_subnet_id field in the default_node_pool block must be set and pod_cidr must not be set.
    network_plugin    = string
    # network_mode can only be set to bridge for existing Kubernetes Clusters and cannot be used to provision new Clusters - this will be removed by Azure in the future.
    network_mode      = string
    network_policy    = string
    outbound_type     = string
    load_balancer_sku = string
    load_balancer     = set(object({
      idle_timeout_in_minutes  = number
      effective_outbound_ips   = list(string)
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
      network_plugin    = "azure"
      network_mode      = "bridge"
      network_policy    = "azure"
      outbound_type     = "loadBalancer"
      load_balancer_sku = "standard"
      load_balancer     = [
        {
          idle_timeout_in_minutes  = 30
          effective_outbound_ips   = []
          outbound_ip_prefix_ids   = []
          outbound_ports_allocated = 0
        }
      ]
      nat_gateway = []
    }
  ]
}

variable "identity" {
  type = set(object({
    type = string
  }))
  default = [
    {
      type = "SystemAssigned"
    }
  ]
}