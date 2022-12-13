data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space       = var.address_spaces
  dns_servers         = var.dns_server
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
    for_each = var.subnet_delegation
    content {
      name = delegation.value.name
      dynamic service_delegation {
        for_each = {
          for k, v in delegation.value.service_delegation : v.name => k
        }
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.action
        }
      }
    }
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}