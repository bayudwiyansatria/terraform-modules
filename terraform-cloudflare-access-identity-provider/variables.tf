variable "account_id" {
  type        = string
  description = "The account identifier to target for the resource"
}

variable "type" {
  type        = list(string)
  description = "The provider type to use. Available values: centrify, facebook, google-apps, oidc, github, google, saml, linkedin, azureAD, okta, onetimepin, onelogin, yandex"
}