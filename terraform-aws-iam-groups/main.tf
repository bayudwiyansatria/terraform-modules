module "group" {
  source = "git::https://github.com/bayudwiyansatria/terraform-modules//terraform-aws-iam-group?ref=develop"
  for_each = {
    for k, v in toset(var.groups) : v.name => k
  }

  name = each.value.name
  path = each.value.path
}
