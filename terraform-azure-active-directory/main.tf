resource "azuread_user" "user" {
  for_each = {
    for k, v in var.users : v.user_principal_name => k
  }

  account_enabled             = each.value.account_enabled
  age_group                   = each.value.age_group
  business_phones             = each.value.business_phones
  city                        = each.value.city
  company_name                = each.value.company_name
  consent_provided_for_minor  = each.value.consent_provided_for_minor
  cost_center                 = each.value.cost_center
  country                     = each.value.country
  department                  = each.value.department
  disable_password_expiration = each.value.disable_password_expiration
  disable_strong_password     = each.value.disable_strong_password
  display_name                = each.value.display_name
  division                    = each.value.division
  employee_id                 = each.value.employee_id
  employee_type               = each.value.employee_type
  fax_number                  = each.value.fax_number
  force_password_change       = each.value.force_password_change
  given_name                  = each.value.given_name
  job_title                   = each.value.job_title
  mail                        = each.value.mail
  mail_nickname               = each.value.mail_nickname
  manager_id                  = each.value.manager_id
  mobile_phone                = each.value.mobile_phone
  office_location             = each.value.office_location
  onpremises_immutable_id     = each.value.onpremises_immutable_id
  other_mails                 = each.value.other_mails
  password                    = each.value.password
  postal_code                 = each.value.postal_code
  preferred_language          = each.value.preferred_language
  show_in_address_list        = each.value.show_in_address_list
  state                       = each.value.state
  street_address              = each.value.street_address
  surname                     = each.value.surname
  usage_location              = each.value.usage_location
  user_principal_name         = each.value.user_principal_name
}