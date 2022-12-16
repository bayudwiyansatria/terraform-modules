data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_aadb2c_directory" "tenant" {
  country_code            = var.country_code
  data_residency_location = var.data_residency_location
  display_name            = var.display_name
  domain_name             = var.domain_name
  resource_group_name     = data.azurerm_resource_group.resource_group.name
  sku_name                = var.sku_name
  tags                    = var.tags
}