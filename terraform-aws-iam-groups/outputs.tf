output "id" {
  value = [
    for i in module.group : i.id
  ]
}
