variable "project_id" {
  type        = string
  description = "MongoDB Atlas ProjectId"
}

variable "name" {
  type        = string
  description = "Name of MongoDB Cluster Name"
}

variable "type" {
  type    = string
  default = "REPLICASET" // Available REPLICASET, SHARDED or GEOSHARDED
}

variable "enable_backup" {
  type        = bool
  description = "Enable Cloud Backup MongoDB Atlas"
  default     = false
}

variable "region_configs" {
  type = set(object({
    backing_provider_name = string
    provider_name         = string
    priority              = number
    region_name           = string
  }))
}

variable "auto_scaling_specs" {
  type = set(object({
    compute_enabled            = bool
    disk_gb_enabled            = bool
    compute_scale_down_enabled = bool
    compute_min_instance_size  = string
    compute_max_instance_size  = string
  }))
  default = []
}

variable "node_specs" {
  type = set(object({
    instance_size = string
  }))
  default = [
    {
      instance_size = "M0"
    }
  ]
}
