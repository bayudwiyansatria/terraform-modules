variable "resource_group_name" {
  type        = string
  description = "The Name of this Resource Group"
}

variable "name" {
  type        = set(string)
  description = "Specifies the name of this User Assigned Identity. Changing this forces a new User Assigned Identity to be created."
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags which should be assigned to the User Assigned Identity."
  default     = {}
}