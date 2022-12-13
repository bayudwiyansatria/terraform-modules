variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "name" {
  description = "The name of the virtual network. Changing this forces a new resource to be created."
}

variable "address_spaces" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space."
  default     = [
    "192.168.0.0/16"
  ]
}

variable "dns_server" {
  type        = list(string)
  description = "List of IP addresses of DNS servers"
  default     = [
    "192.168.0.4",
    "192.168.0.5"
  ]
}

variable "subnet" {
  type = set(object({
    name           = string
    address_prefix = list(string)
  }))
  default = [
    {
      name           = "default"
      address_prefix = [
        "192.168.0.0/24"
      ]
    }
  ]
}

variable "subnet_delegation" {
  type = set(object({
    name               = string
    service_delegation = set(object({
      name   = string
      action = list(string)
    }))
  }))
  default = [
    {
      name               = "delegation"
      service_delegation = [
        {
          name   = "Microsoft.ContainerInstance/containerGroups"
          action = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          ]
        }
      ]
    }
  ]
}