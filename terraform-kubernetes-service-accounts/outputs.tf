output "id" {
  value = [
    for i in module.service_accounts : i.id
  ]
}

output "name" {
  value = [
    for i in var.account : i.name
  ]
}
