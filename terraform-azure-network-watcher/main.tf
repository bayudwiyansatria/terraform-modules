data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_network_watcher" "watcher" {
  name                = var.name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}