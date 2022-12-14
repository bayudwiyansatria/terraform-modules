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
  default     = []
}

variable "subnet" {
  type = set(object({
    name              = string
    address_prefix    = list(string)
    subnet_delegation = set(object({
      name               = string
      service_delegation = set(object({
        name   = string
        action = list(string)
      }))
    }))
  }))
  default = [
    {
      name           = "default"
      address_prefix = [
        "192.168.0.0/24"
      ]
      subnet_delegation = [
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
  ]
}

#variable "interfaces" {
#  type = set(object({
#
#  }))
#}

variable "routing" {
  type = set(object({
    name                   = string
    address_prefix         = string
    # The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None
    next_hop_type          = string
    # Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
    next_hop_in_ip_address = string
  }))
  default = [
    {
      name                   = "default"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "Internet"
      next_hop_in_ip_address = null
    }
  ]
}


variable "secure" {
  type = set(object({
    name                                       = string
    description                                = string
    protocol                                   = any
    source_port_range                          = any
    destination_port_range                     = any
    source_address_prefix                      = any
    source_application_security_group_ids      = list(any)
    destination_address_prefix                 = any
    destination_application_security_group_ids = list(any)
    access                                     = bool
    priority                                   = number
    direction                                  = bool
  }))
  default = [
    {
      name                                       = "allow-inbound"
      description                                = "Allow Any Request"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      source_application_security_group_ids      = []
      destination_address_prefix                 = "*"
      destination_application_security_group_ids = []
      access                                     = true
      priority                                   = 100
      direction                                  = true
    },
    {
      name                                       = "allow-outbound"
      description                                = "Allow Any Request"
      protocol                                   = "*"
      source_port_range                          = "*"
      destination_port_range                     = "*"
      source_address_prefix                      = "*"
      source_application_security_group_ids      = []
      destination_address_prefix                 = "*"
      destination_application_security_group_ids = []
      access                                     = true
      priority                                   = 101
      direction                                  = false
    }
  ]
}