data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_communication_service" "communication_service" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  data_location       = var.data_location
  tags                = var.tags
}
