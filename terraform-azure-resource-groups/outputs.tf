output "resource_groups" {
  value = [
    for i in module.resource_groups : {
      id   = i.id
      name = i.name
    }
  ]
}
