locals {
  projects = flatten([
    for project in data.mongodbatlas_project.project.* : [
      for k, v in project : {
        id   = k
        name = v.name
      }
    ]
  ])
}

resource "mongodbatlas_project_ip_access_list" "whitelist" {
  for_each = {
    for tuple in setproduct(var.ip_address, local.projects) : "${tuple[1].name}-${replace(tuple[0], "." , "-")}"
    => {
      project_id = tuple[1].id
      ip_address = tuple[0]
    }
  }
  project_id = each.value.project_id
  ip_address = each.value.ip_address

  depends_on = [
    data.mongodbatlas_project.project
  ]
}