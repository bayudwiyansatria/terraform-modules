#data "azurerm_cosmosdb_account" "example" {
#  name                = "tfex-cosmosdb-account"
#  resource_group_name = "tfex-cosmosdb-account-rg"
#}
#
#resource "azurerm_cosmosdb_mongo_database" "example" {
#  for_each =
#  name                = "tfex-cosmos-mongo-db"
#  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
#  account_name        = data.azurerm_cosmosdb_account.example.name
#}
#
#resource "azurerm_cosmosdb_mongo_collection" "example" {
#  fo
#  name                = "tfex-cosmos-mongo-db"
#  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
#  account_name        = data.azurerm_cosmosdb_account.example.name
#  database_name       = azurerm_cosmosdb_mongo_database.example.name
#
#  default_ttl_seconds = "777"
#  shard_key           = "uniqueKey"
#  throughput          = 400
#
#  index {
#    keys   = ["_id"]
#    unique = true
#  }
#}

locals {

}