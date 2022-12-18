variable "name" {
  type        = string
  description = "The name of the cluster, unique within the project and location."
}

variable "location" {
  type        = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
  default     = "asia-southeast2-a"
}

variable "node_locations" {
  type        = set(string)
  description = "The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If this is specified for a zonal cluster, omit the cluster's zone."
  default     = null
}

variable "addons_config" {
  type = set(object({
    horizontal_pod_autoscaling = set(object({
      disabled = bool
    }))
    http_load_balancing = set(object({
      disabled = bool
    }))
    network_policy_config = set(object({
      disabled = bool
    }))
    gcp_filestore_csi_driver_config = set(object({
      enabled = bool
    }))
    cloudrun_config = set(object({
      disabled           = bool
      load_balancer_type = string
    }))
    #    istio_config = set(object({
    #      disabled = bool
    #      # The authentication type between services in Istio. Available options include AUTH_MUTUAL_TLS.
    #      auth     = string
    #    }))
    #    identity_service_config = set(object({
    #      enabled = bool
    #    }))
    #    dns_cache_config = set(object({
    #      enabled = bool
    #    }))
    #    gce_persistent_disk_csi_driver_config = set(object({
    #      enabled = bool
    #    }))
    #    kalm_config = set(object({
    #      enabled = bool
    #    }))
    #    config_connector_config = set(object({
    #      enabled = bool
    #    }))
    #    gke_backup_agent_config = set(object({
    #      enabled = bool
    #    }))
  }))
  description = ""
  default     = []
}

variable "cluster_ipv4_cidr" {
  type        = string
  description = "The IP address range of the Kubernetes pods in this cluster in CIDR notation (e.g. 10.96.0.0/14). Leave blank to have one automatically chosen or specify a /14 block in 10.0.0.0/8. This field will only work for routes-based clusters, where ip_allocation_policy is not defined."
  default     = null
}

variable "cluster_autoscaling" {
  type = set(object({
    enabled         = bool
    resource_limits = set(object({
      # The type of the resource. For example, cpu and memory. See the guide to using Node Auto-Provisioning for a list of types.
      resource_type = string
      minimum       = number
      maximum       = number
    }))
    auto_provisioning_defaults = set(object({
      # Minimum CPU platform to be used for NAP created node pools. The instance may be scheduled on the specified or newer CPU platform. Applicable values are the friendly names of CPU platforms, such as "Intel Haswell" or "Intel Sandy Bridge".
      min_cpu_platform         = string
      # Scopes that are used by NAP and GKE Autopilot when creating node pools. Use the "https://www.googleapis.com/auth/cloud-platform" scope to grant access to all APIs. It is recommended that you set service_account to a non-default service account and grant IAM roles to that service account for only the resources that it needs.
      oauth_scopes             = string
      service_account          = string
      boot_disk_kms_key        = string
      # Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100
      disk_size                = number
      # Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced'). Defaults to pd-standard
      disk_type                = string
      # The default image type used by NAP once a new node pool is being created. Please note that according to the official documentation the value must be one of the [COS_CONTAINERD, COS, UBUNTU_CONTAINERD, UBUNTU]. NOTE : COS AND UBUNTU are deprecated as of GKE 1.24
      image_type               = string
      shielded_instance_config = set(object({
        enable_secure_boot = bool
      }))
      management = set(object({
        auto_upgrade = bool
        auto_repair  = bool
      }))
    }))
    # Configuration options for the Autoscaling profile feature, which lets you choose whether the cluster autoscaler should optimize for resource utilization or resource availability when deciding to remove nodes from a cluster. Can be BALANCED or OPTIMIZE_UTILIZATION. Defaults to BALANCED.
    autoscaling_profile = string
  }))
  description = "Per-cluster configuration of Node Auto-Provisioning with Cluster Autoscaler to automatically adjust the size of the cluster and create/delete node pools based on the current needs of the cluster's workload"
  default     = []
}

#variable "binary_authorization" {
#  type = set(object({
#    # Mode of operation for Binary Authorization policy evaluation. Valid values are DISABLED and PROJECT_SINGLETON_POLICY_ENFORCE.
#    evaluation_mode = string
#  }))
#  description = ""
#  default     = []
#}

#variable "service_external_ips_config" {
#  type = set(object({
#    enabled = bool
#  }))
#  description = ""
#  default     = []
#}

#variable "mesh_certificates" {
#  type = set(object({
#    enable_certificates = bool
#  }))
#  description = ""
#  default     = []
#}

variable "database_encryption" {
  type = set(object({
    # ENCRYPTED or DECRYPTED
    state    = string
    key_name = string
  }))
  description = ""
  default     = []
}

variable "description" {
  type        = string
  description = "Description of the cluster."
  default     = null
}

#variable "default_max_pods_per_node" {
#  type        = number
#  description = "The default maximum number of pods per node in this cluster. This doesn't work on routes-based clusters, clusters that don't have IP Aliasing enabled. See the official documentation for more information."
#  default     = 0
#}

variable "enable_kubernetes_alpha" {
  type        = bool
  description = "Whether to enable Kubernetes Alpha features for this cluster. Note that when this option is enabled, the cluster cannot be upgraded and will be automatically deleted after 30 days."
  default     = false
}

variable "enable_tpu" {
  type        = bool
  description = "Whether to enable Cloud TPU resources in this cluster. See the official documentation."
  default     = false
}

variable "enable_legacy_abac" {
  type        = bool
  description = "Whether the ABAC authorizer is enabled for this cluster. When enabled, identities in the system, including service accounts, nodes, and controllers, will have statically granted permissions beyond those provided by the RBAC configuration or IAM."
  default     = false
}

#variable "enable_shielded_nodes" {
#  type        = bool
#  description = "Enable Shielded Nodes features on all nodes in this cluster."
#  default     = true
#}

variable "enable_autopilot" {
  type        = bool
  description = "Enable Autopilot for this cluster."
  default     = false
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Must be set if node_pool is not set. If you're using google_container_node_pool objects with no default node pool, you'll need to set this to a value of at least 1, alongside setting remove_default_node_pool to true."
  default     = 1
}

variable "ip_allocation_policy" {
  type = set(object({
    cluster_secondary_range_name  = string
    services_secondary_range_name = string
    cluster_ipv4_cidr_block       = string
    services_ipv4_cidr_block      = string
  }))
  description = "Configuration of cluster IP allocation for VPC-native clusters. Adding this block enables IP aliasing, making the cluster VPC-native instead of routes-based. Structure is documented below."
  default     = []
}

variable "networking_mode" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com(Legacy Stackdriver), logging.googleapis.com/kubernetes(Stackdriver Kubernetes Engine Logging), and none. Defaults to logging.googleapis.com/kubernetes"
  default     = "logging.googleapis.com/kubernetes"
}

variable "logging_config" {
  type = set(object({
    # The GKE components exposing logs. Supported values include: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, SCHEDULER, and WORKLOADS.
    enable_components = string
  }))
  description = ""
  default     = []
}

variable "maintenance_policy" {
  type = set(object({
    daily_maintenance_window = set(object({
      # Time window specified for daily maintenance operations. Specify start_time in RFC3339 format "HH:MM”, where HH : [00-23] and MM : [00-59] GMT
      start_time = string
    }))
    recurring_window = set(object({
      # i.e "2019-08-01T02:00:00Z"
      start_time = string
      end_time   = string
      # i.e "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
      recurrence = string
    }))
    maintenance_exclusion = set(object({
      exclusion_name    = string
      start_time        = string
      end_time          = string
      exclusion_options = set(object({
        # NO_UPGRADES | NO_MINOR_UPGRADES | NO_MINOR_OR_NODE_UPGRADES
        scope = string
      }))
    }))

  }))
  description = ""
  default     = []
}

variable "master_auth" {
  type = set(object({
    client_certificate_config = set(object({
      issue_client_certificate = bool
    }))
  }))
  description = "The authentication information for accessing the Kubernetes master. Some values in this block are only returned by the API if your service account has permission to get credentials for your GKE cluster. If you see an unexpected diff unsetting your client cert, ensure you have the container.clusters.getCredentials permission."
  default     = []
}

variable "master_authorized_networks_config" {
  type = set(object({
    cidr_blocks = set(object({
      cidr_block   = string
      display_name = string
    }))
    gcp_public_cidrs_access_enabled = bool
  }))
  description = "The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "min_master_version" {
  type        = string
  description = "The minimum version of the master. GKE will auto-update the master to new versions, so this does not guarantee the current master version--use the read-only master_version field to obtain that. If unset, the cluster's version will be set by GKE to the version of the most recent official release (which is not necessarily the latest version). Most users will find the google_container_engine_versions data source useful - it indicates which versions are available, and can be use to approximate fuzzy versions in a Terraform-compatible way. If you intend to specify versions manually, the docs describe the various acceptable formats for this field."
  default     = null
}

variable "monitoring_config" {
  type = set(object({
    # The GKE components exposing metrics. Supported values include: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, and SCHEDULER. In beta provider, WORKLOADS is supported on top of those 4 values. (WORKLOADS is deprecated and removed in GKE 1.24.)
    enable_components = string
    #    managed_prometheus = set(object({
    #      enabled = bool
    #    }))
  }))
  description = ""
  default     = []
}

variable "monitoring_service" {
  type        = string
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com(Legacy Stackdriver), monitoring.googleapis.com/kubernetes(Stackdriver Kubernetes Engine Monitoring), and none. Defaults to monitoring.googleapis.com/kubernetes"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "network" {
  type        = string
  description = "The name or self_link of the Google Compute Engine network to which the cluster is connected. For Shared VPC, set this to the self link of the shared network."
  default     = null
}

variable "network_policy" {
  type = set(object({
    # PROVIDER_UNSPECIFIED
    provider = string
    enabled  = bool
  }))
  description = ""
  default     = []
}

variable "node_config" {
  type = set(object({
    disk_size_gb = number
    disk_type    = string
    #    ephemeral_storage_config = set(object({
    #      local_ssd_count = number
    #    }))
    # Parameter for specifying the type of logging agent used in a node pool. This will override any cluster-wide default value. Valid values include DEFAULT and MAX_THROUGHPUT.
    #    logging_variant = string
    gcfs_config  = set(object({
      enabled = bool
    }))
    gvnic = set(object({
      enabled = bool
    }))
    guest_accelerator = set(object({
      type               = string
      count              = number
      gpu_partition_size = string
      #      gpu_sharing_config = set(object({
      #        # "TIME_SHARING": Allow multiple containers to have time-shared access to a single GPU device.
      #        gpu_sharing_strategy       = string
      #        max_shared_clients_per_gpu = number
      #      }))
    }))
    image_type               = string
    labels                   = map(any)
    #    resource_labels      = map(any)
    local_ssd_count          = number
    machine_type             = string
    metadata                 = map(any)
    min_cpu_platform         = string
    oauth_scopes             = set(string)
    preemptible              = bool
    #    reservation_affinity = set(object({
    #      # "UNSPECIFIED": Default value. This should not be used.
    #      # "NO_RESERVATION": Do not consume from any reserved capacity.
    #      # "ANY_RESERVATION": Consume any reservation available.
    #      # "SPECIFIC_RESERVATION": Must consume from a specific reservation. Must specify key value fields for specifying the reservations.
    #      consume_reservation_type = string
    #      key                      = any
    #      values                   = any
    #    }))
    spot                     = bool
    boot_disk_kms_key        = string
    service_account          = string
    shielded_instance_config = set(object({
      enable_secure_boot          = bool
      enable_integrity_monitoring = bool
    }))
    tags  = map(any)
    taint = set(object({
      key    = string
      value  = string
      # Effect for taint. Accepted values are NO_SCHEDULE, PREFER_NO_SCHEDULE, and NO_EXECUTE.
      effect = string
    }))
    workload_metadata_config = set(object({
      # MODE_UNSPECIFIED: Not Set
      # GCE_METADATA: Expose all Compute Engine metadata to pods.
      # GKE_METADATA: Run the GKE Metadata Server on this node. The GKE Metadata Server exposes a metadata API to workloads that is compatible with the V1 Compute Metadata APIs exposed by the Compute Engine and App Engine Metadata Servers. This feature can only be enabled if workload identity is enabled at the cluster level.
      mode = string
    }))
    #    kubelet_config = set(object({
    #      cpu_manager_policy   = string
    #      cpu_cfs_quota        = bool
    #      cpu_cfs_quota_period = string
    #    }))
    #    linux_node_config = set(object({
    #      sysctls = set(map(any))
    #    }))
    node_group = string
  }))
  description = "Parameters used in creating the default node pool. Generally, this field should not be used at the same time as a google_container_node_pool or a node_pool block"
  default     = []
}

variable "node_pool" {
  type        = set(string)
  description = "List of node pools associated with this cluster. See google_container_node_pool for schema. Warning: node pools defined inside a cluster can't be changed (or added/removed) after cluster creation without deleting and recreating the entire cluster. Unless you absolutely need the ability to say these are the only node pools associated with this cluster, use the google_container_node_pool resource instead of this property."
  default     = []
}

#variable "node_pool_auto_config" {
#  type = set(object({
#    network_tags = set(object({
#      tags = set(string)
#    }))
#  }))
#  description = "Node pool configs that apply to auto-provisioned node pools in autopilot clusters and node auto-provisioning-enabled clusters."
#  default     = []
#}

#variable "node_pool_defaults" {
#  type = set(object({
#    logging_variant = string
#    gcfs_config     = set(object({
#      enabled = bool
#    }))
#
#  }))
#  description = "Default NodePool settings for the entire cluster"
#  default     = []
#}

variable "node_version" {
  type        = string
  description = "The Kubernetes version on the nodes. Must either be unset or set to the same value as min_master_version on create. Defaults to the default version set by GKE which is not necessarily the latest version. This only affects nodes in the default node pool. While a fuzzy version can be specified, it's recommended that you specify explicit versions as Terraform will see spurious diffs when fuzzy versions are used. See the google_container_engine_versions data source's version_prefix field to approximate fuzzy versions in a Terraform-compatible way. To update nodes in other node pools, use the version attribute on the node pool."
  default     = null
}

#variable "notification_config" {
#  type = set(object({
#    pubsub = set(object({
#      enabled = bool
#      topic   = string
#      filter  = set(object({
#        # Can be used to filter what notifications are sent. Accepted values are UPGRADE_AVAILABLE_EVENT, UPGRADE_EVENT and SECURITY_BULLETIN_EVENT.
#        event_type = string
#      }))
#    }))
#  }))
#  description = ""
#  default     = []
#}

variable "confidential_nodes" {
  type = set(object({
    enabled = bool
  }))
  description = ""
  default     = []
}

#variable "pod_security_policy_config" {
#  type = set(object({
#    enabled = bool
#  }))
#  description = ""
#  default     = []
#}

variable "authenticator_groups_config" {
  type = set(object({
    security_group = string
  }))
  description = ""
  default     = []
}

variable "private_cluster_config" {
  type = set(object({
    enable_private_nodes        = bool
    enable_private_endpoint     = bool
    master_ipv4_cidr_block      = string
    master_global_access_config = set(object({
      enabled = bool
    }))
  }))
  description = ""
  default     = []
}

#variable "cluster_telemetry" {
#  type = set(object({
#    # Telemetry integration for the cluster. Supported values (ENABLED, DISABLED, SYSTEM_ONLY); SYSTEM_ONLY (Only system components are monitored and logged) is only available in GKE versions 1.15 and later.
#    type = string
#  }))
#  description = ""
#  default     = []
#}

variable "project" {
  type        = string
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "release_channel" {
  type = set(object({
    # UNSPECIFIED: Not set.
    # RAPID: Weekly upgrade cadence; Early testers and developers who requires new features.
    # REGULAR: Multiple per month upgrade cadence; Production users who need features not yet offered in the Stable channel.
    # STABLE: Every few months upgrade cadence; Production users who need stability above all else, and for whom frequent upgrades are too risky.
    channel = string
  }))
  description = "Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters. When updating this field, GKE imposes specific version requirements. See Selecting a new release channel for more details; the google_container_engine_versions datasource can provide the default version for a channel. Note that removing the release_channel field from your config will cause Terraform to stop managing your cluster's release channel, but will not unenroll it. Instead, use the UNSPECIFIED channel"
  default     = []
}

variable "remove_default_node_pool" {
  type        = bool
  description = "If true, deletes the default node pool upon cluster creation. If you're using google_container_node_pool resources with no default node pool, this should be set to true, alongside setting initial_node_count to at least 1."
  default     = true
}

variable "resource_labels" {
  type        = map(any)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  default     = {}
}

#variable "cost_management_config" {
#  type = set(object({
#    enabled = bool
#  }))
#  description = ""
#  default     = []
#}

variable "resource_usage_export_config" {
  type = set(object({
    enable_network_egress_metering       = bool
    enable_resource_consumption_metering = bool
    bigquery_destination                 = set(object({
      dataset_id = string
    }))
  }))
  description = ""
  default     = []
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the Google Compute Engine subnetwork in which the cluster's instances are launched."
  default     = null
}

variable "vertical_pod_autoscaling" {
  type = set(object({
    enabled = bool
  }))
  description = ""
  default     = []
}

variable "workload_identity_config" {
  type = set(object({
    workload_pool = string
  }))
  description = ""
  default     = []
}

variable "enable_intranode_visibility" {
  type        = bool
  description = "Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network."
  default     = null
}

#variable "enable_l4_ilb_subsetting" {
#  type        = bool
#  description = "Whether L4ILB Subsetting is enabled for this cluster."
#  default     = null
#}

#variable "private_ipv6_google_access" {
#  type        = string
#  description = "The desired state of IPv6 connectivity to Google Services. By default, no private IPv6 access to or from Google Services (all access will be via IPv4)."
#  default     = null
#}

variable "datapath_provider" {
  type        = string
  description = "The desired datapath provider for this cluster. By default, uses the IPTables-based kube-proxy implementation."
  default     = null
}

variable "default_snat_status" {
  type = set(object({
    disabled = bool
  }))
  description = " GKE SNAT DefaultSnatStatus contains the desired state of whether default sNAT should be disabled on the cluster, API doc."
  default     = []
}

variable "dns_config" {
  type = set(object({
    # Which in-cluster DNS provider should be used. PROVIDER_UNSPECIFIED (default) or PLATFORM_DEFAULT or CLOUD_DNS.
    cluster_dns        = string
    # The scope of access to cluster DNS records. DNS_SCOPE_UNSPECIFIED (default) or CLUSTER_SCOPE or VPC_SCOPE.
    cluster_dns_scope  = string
    cluster_dns_domain = string
  }))
  description = ""
  default     = []
}
