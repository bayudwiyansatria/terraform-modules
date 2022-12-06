locals {
  users = {
    for tuple in setproduct(var.users, var.projects) : "${tuple[1]}-${tuple[0].username}" => {
      project_id              = tuple[1]
      username                = tuple[0].username
      password                = tuple[0].password
      authentication_database = tuple[0].authentication_database
    }
  }
}

resource "mongodbatlas_database_user" "database_user" {
  for_each           = local.users
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