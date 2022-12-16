resource "azurerm_subscription" "subscription" {
  subscription_name = var.subscription_name
  billing_scope_id  = var.billing_id
}