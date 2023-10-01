output "id" {
  value = [
    for i in aws_iam_user.users : i.id
  ]
}
