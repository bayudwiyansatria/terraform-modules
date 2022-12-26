module "resource_groups" {
  source   = "git::https://github.com/bayudwiyansatria/terraform-modules//terraform-azure-resource-group?ref=master"
  for_each = {
    for k, v in toset(var.groups) : v.name => k
  }
  name     = each.value.name
  location = each.value.location
}
