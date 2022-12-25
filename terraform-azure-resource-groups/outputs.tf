output "resource_group" {
  value = [
    for i in module.resource_group : {
      id   = i.id
      name = i.name
    }
  ]
}
