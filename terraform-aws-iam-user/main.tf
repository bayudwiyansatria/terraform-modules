resource "aws_iam_user" "users" {
  source               = "git::https://github.com/bayudwiyansatria/terraform-modules//terraform-aws-iam-group?ref=develop"
  name                 = var.name
  path                 = var.name
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
}
