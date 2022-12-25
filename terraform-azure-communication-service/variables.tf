variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the Communication Service should exist."
}

variable "name" {
  type        = string
  description = "The name of the Communication Service resource. Changing this forces a new Communication Service to be created."
}

variable "data_location" {
  type        = string
  description = "The location where the Communication service stores its data at rest."
  default     = "Asia Pacific"
  validation {
    condition = contains([
      "Africa",
      "Asia Pacific",
      "Australia",
      "Brazil",
      "Canada",
      "Europe",
      "France",
      "Germany",
      "India",
      "Japan",
      "Korea",
      "Norway",
      "Switzerland",
      "UAE",
      "UK",
      "United States"
    ])
    error_message = "Data Location is Not Valid. Available: Possible values are Africa, Asia Pacific, Australia, Brazil, Canada, Europe, France, Germany, India, Japan, Korea, Norway, Switzerland, UAE, UK and United States."
  }
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the Communication Service."
  default     = {}
}