output "id" {
  value = [
    for i in azuread_user.user : i.id
  ]
}