data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space       = var.address_spaces

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_virtual_network_dns_servers" "example" {
  virtual_network_id = azurerm_virtual_network.vnet.id
  dns_servers        = var.dns_server

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for k, v in var.subnet : v.name => k
  }
  name                 = "${azurerm_virtual_network.vnet.name}-${each.value.name}"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefix

  dynamic delegation {
    for_each = toset(each.value.subnet_delegation)
    content {
      name = delegation.value.name

      dynamic service_delegation {
        for_each = toset(delegation.value.service_delegation)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.action
        }
      }

    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_route_table.route

  ]
}

#resource "azurerm_network_interface" "example" {
#  name                = azurerm_virtual_network.vnet.name
#  location            = data.azurerm_resource_group.resource_group.location
#  resource_group_name = data.azurerm_resource_group.resource_group.name
#
#  ip_configuration {
#    name                          = "internal"
#    subnet_id                     = azurerm_subnet.example.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}

resource "azurerm_route_table" "route" {
  name                = azurerm_virtual_network.vnet.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  dynamic "route" {
    for_each = var.routing
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? route.value.next_hop_in_ip_address : null
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_route_table_association" "associated" {
  for_each = {
    for k, v in azurerm_subnet.subnet : k => {
      id = v.id
    }
  }
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.route.id

  depends_on = [
    azurerm_route_table.route,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_network_security_group" "security" {
  name                = azurerm_virtual_network.vnet.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  dynamic "security_rule" {
    for_each = var.secure
    content {
      name                                       = security_rule.value.name
      description                                = security_rule.value.description
      protocol                                   = security_rule.value.protocol
      source_port_range                          = security_rule.value.source_port_range
      destination_port_range                     = security_rule.value.destination_port_range
      source_address_prefix                      = security_rule.value.source_address_prefix
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids
      destination_address_prefix                 = security_rule.value.destination_address_prefix
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
      access                                     = security_rule.value.access == true ? "Allow" : "Deny"
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction == true ? "Inbound" : "Outbound"
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "associated" {
  for_each = {
    for k, v in azurerm_subnet.subnet : k => {
      id = v.id
    }
  }
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.security.id

  depends_on = [
    azurerm_route_table.route,
    azurerm_subnet.subnet
  ]
}