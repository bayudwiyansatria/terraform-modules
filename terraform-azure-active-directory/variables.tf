variable "users" {
  type = set(object({
    account_enabled             = bool
    # The age group of the user. Supported values are Adult, NotAdult and Minor. Omit this property or specify a blank string to unset.
    age_group                   = string
    business_phones             = string
    city                        = string
    company_name                = string
    # Whether consent has been obtained for minors. Supported values are Granted, Denied and NotRequired. Omit this property or specify a blank string to unset.
    consent_provided_for_minor  = string
    cost_center                 = string
    country                     = string
    department                  = string
    # Whether the user's password is exempt from expiring. Defaults to false.
    disable_password_expiration = bool
    # Whether the user is allowed weaker passwords than the default policy to be specified. Defaults to false.
    disable_strong_password     = bool
    display_name                = string
    division                    = string
    employee_id                 = string
    # Captures enterprise worker type. For example, Employee, Contractor, Consultant, or Vendor.
    employee_type               = string
    fax_number                  = string
    # Whether the user is forced to change the password during the next sign-in. Only takes effect when also changing the password. Defaults to false.
    force_password_change       = bool
    given_name                  = string
    job_title                   = string
    mail                        = string
    # The mail alias for the user. Defaults to the user name part of the user principal name (UPN).
    mail_nickname               = string
    manager_id                  = string
    mobile_phone                = string
    office_location             = string
    # The value used to associate an on-premise Active Directory user account with their Azure AD user object. This must be specified if you are using a federated domain for the user's user_principal_name property when creating a new user account.
    onpremises_immutable_id     = string
    other_mails                 = list(string)
    # The password for the user. The password must satisfy minimum requirements as specified by the password policy. The maximum length is 256 characters. This property is required when creating a new user.
    password                    = any
    postal_code                 = number
    # The user's preferred language, in ISO 639-1 notation.
    preferred_language          = string
    # Whether or not the Outlook global address list should include this user. Defaults to true.
    show_in_address_list        = bool
    state                       = string
    street_address              = string
    surname                     = string
    # The usage location of the user. Required for users that will be assigned licenses due to legal requirement to check for availability of services in countries. The usage location is a two letter country code (ISO standard 3166). Examples include: NO, JP, and GB. Cannot be reset to null once set.
    usage_location              = string
    user_principal_name         = string
  }))
}