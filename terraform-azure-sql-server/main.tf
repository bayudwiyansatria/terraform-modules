resource "azurerm_mssql_server" "mssql_server" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  name                         = var.mssql_server_name
  version                      = var.mssql_server_version
  administrator_login          = var.mssql_server_admin
  administrator_login_password = var.mssql_server_password

  connection_policy                            = var.mssql_server_connection_policy
  transparent_data_encryption_key_vault_key_id = var.mssql_server_transparent_data_encryption_key_vault_key_id
  minimum_tls_version                          = var.mssql_server_minimum_tls_version
  public_network_access_enabled                = var.mssql_server_public_network_access_enabled
  outbound_network_restriction_enabled         = var.mssql_server_outbound_network_restriction_enabled
  # primary_user_assigned_identity_id            = var.mssql_server_primary_user_assigned_identity_id


  dynamic "azuread_administrator" {
    for_each = var.mssql_server_azuread_administrator
    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
    }
  }
}
