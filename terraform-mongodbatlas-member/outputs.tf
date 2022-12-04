output "id" {
  value = [for member in mongodbatlas_org_invitation.member : member.id]
}