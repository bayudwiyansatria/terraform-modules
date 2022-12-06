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

resource "mongodbatlas_database_user" "database_user" {
  for_each = {
    for tuple in setproduct(var.users, local.projects) : "${tuple[1].name}-${tuple[0].name}"=> {
      project_id              = tuple[1].id
      username                = tuple[0].username
      password                = tuple[0].password
      authentication_database = tuple[0].authentication_database
    }
  }
  username           = each.value.username
  password           = each.value.password
  project_id         = each.value.project_id
  auth_database_name = each.value.authentication_database

  dynamic "roles" {
    for_each = var.roles
    content {
      role_name     = roles.value.role_name
      database_name = roles.value.database_name
    }
  }

  dynamic "scopes" {
    for_each = var.scopes
    content {
      name = scopes.value.name
      type = scopes.value.type
    }
  }

}