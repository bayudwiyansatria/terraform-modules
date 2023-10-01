variable "name" {
  type        = string
  description = "The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces."
}

variable "path" {
  type        = string
  description = "Path in which to create the user."
  default     = "/"
}

variable "permissions_boundary" {
  type        = string
  description = "The ARN of the policy that is used to set the permissions boundary for the user."
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "force_destroy" {
  type        = bool
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices."
  default     = false
}
