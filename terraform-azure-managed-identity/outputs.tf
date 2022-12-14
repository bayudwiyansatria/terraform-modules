output "id" {
  value = [for i in azurerm_user_assigned_identity.user : i.id]
}
