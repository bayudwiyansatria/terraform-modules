resource "azurerm_user_assigned_identity" "user" {
  for_each            = var.name
  name                = each.value
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  tags = var.tags
}