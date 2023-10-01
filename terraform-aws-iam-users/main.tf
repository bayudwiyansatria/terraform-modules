module "user" {
  source = "git::https://github.com/bayudwiyansatria/terraform-modules//terraform-aws-iam-user?ref=develop"
  for_each = {
    for k, v in toset(var.users) : v.name => k
  }

  name                 = each.value.name
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary
  force_destroy        = each.value.force_destroy
}
