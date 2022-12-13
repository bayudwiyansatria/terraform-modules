variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group"
}

variable "cluster_name" {
  type        = string
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
}

variable "node_pool" {
  type = set(object({
    name       = string
    node_count = number
    vm_size    = string
  }))
  default = [
    {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_D2_v2"
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