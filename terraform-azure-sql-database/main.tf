resource "azurerm_mssql_database" "mssql_database" {
  name                 = var.mssql_database_name
  server_id            = var.mssql_server_id
  collation            = var.mssql_collation
  license_type         = var.mssql_database_license_type
  max_size_gb          = var.mssql_database_max_size_gb
  read_scale           = var.mssql_database_read_scale
  sku_name             = var.mssql_database_sku_name
  zone_redundant       = var.mssql_database_zone_redundant
  storage_account_type = var.mssql_database_storage_account_type
}
