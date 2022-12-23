module "service_accounts" {
  source   = "git::https://github.com/bayudwiyansatria/terraform-modules//terraform-kubernetes-service-account?ref=master"
  for_each = {
    for k, v in toset(var.account) : v.name => k
  }
  image_pull_secret = each.value.image_pull_secret
  metadata          = each.value.metadata
  name              = each.value.name
  secret            = each.value.secret
}
