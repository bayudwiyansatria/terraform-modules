resource "aws_iam_group_membership" "group_membership" {
  name  = var.group_name
  users = var.users
  group = var.group_name
}
