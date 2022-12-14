variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to the Application Gateway should exist."
}

variable "name" {
  type        = set(string)
  description = "The name of the Application Gateway. Changing this forces a new resource to be created."
}

variable "backend_address_pool" {
  type = set(object({
    name         = string
    fqdns        = list(string)
    ip_addresses = list(string)
  }))
  default = [
    {
      name         = "default"
      fqdns        = []
      ip_addresses = []
    }
  ]
}

variable "backend_http_settings" {
  type = set(object({
    authentication_certificate = set(object({
      name = string
    }))
    #  Is Cookie-Based Affinity enabled? Possible values are Enabled and Disabled.
    cookie_based_affinity               = string
    affinity_cookie_name                = string
    name                                = string
    path                                = string
    port                                = string
    probe_name                          = string
    # The Protocol which should be used. Possible values are Http and Https.
    protocol                            = string
    request_timeout                     = number
    # (Optional) Host header to be sent to the backend servers. Cannot be set if pick_host_name_from_backend_address is set to true.
    host_name                           = string
    # (Optional) Whether host header should be picked from the host name of the backend server
    pick_host_name_from_backend_address = string
    trusted_root_certificate_names      = list(string)
    connection_draining                 = set(object({
      enabled           = bool
      drain_timeout_sec = number
    }))
  }))
  default = [
    {
      authentication_certificate          = []
      cookie_based_affinity               = "Disabled"
      affinity_cookie_name                = ""
      name                                = ""
      path                                = ""
      port                                = ""
      probe_name                          = ""
      protocol                            = "Http"
      request_timeout                     = 30
      host_name                           = null
      pick_host_name_from_backend_address = true
      trusted_root_certificate_names      = []
      connection_draining                 = []
    }
  ]
}

variable "frontend_ip_configuration" {
  type = set(object({
    name                            = string
    subnet_id                       = string
    private_ip_address              = string
    # The ID of a Public IP Address which the Application Gateway should use. The allocation method for the Public IP Address depends on the sku of this Application Gateway.
    public_ip_address_id            = string
    # The Allocation Method for the Private IP Address. Possible values are Dynamic and Static.
    private_ip_address_allocation   = string
    # The name of the private link configuration to use for this frontend IP configuration.
    private_link_configuration_name = string
  }))
  default = []
}

variable "frontend_port" {
  type = set(object({
    name = string
    port = number
  }))
  default = [
    {
      name = "default"
      port = 80
    }
  ]
}

variable "gateway_ip_configuration" {
  type = set(object({
    name      = string
    subnet_id = string
  }))
  default = [
    {
      name      = "default"
      subnet_id = null
    }
  ]
}

variable "http_listener" {
  type = set(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    host_name                      = string
    host_names                     = list(string)
    # The Protocol to use for this HTTP Listener. Possible values are Http and Https.
    protocol                       = string
    require_sni                    = string
    ssl_certificate_name           = string
    custom_error_configuration     = string
    firewall_policy_id             = string
    ssl_profile_name               = string
  }))
  default = [
    {
      name                           = "default"
      frontend_ip_configuration_name = null
      frontend_port_name             = null
      host_name                      = null
      host_names                     = ["*"]
      protocol                       = "Http"
      require_sni                    = null
      ssl_certificate_name           = null
      custom_error_configuration     = null
      firewall_policy_id             = null
      ssl_profile_name               = null
    }
  ]
}

variable "fips_enabled" {
  type        = bool
  description = "Is FIPS enabled on the Application Gateway"
  default     = false
}

variable "global" {
  type = set(object({
    request_buffering_enabled  = bool
    response_buffering_enabled = bool
  }))
  default = [
    {
      request_buffering_enabled  = true
      response_buffering_enabled = true
    }
  ]
}

variable "identity" {
  type = set(object({
    type         = string
    identity_ids = list(string)
  }))
}

variable "private_link_configuration" {
  type = set(object({
    name             = string
    ip_configuration = set(object({
      name                          = string
      subnet_id                     = string
      # The allocation method used for the Private IP Address. Possible values are Dynamic and Static.
      private_ip_address_allocation = string
      primary                       = bool
      private_ip_address            = string
    }))
  }))
  default = []
}

variable "request_routing_rule" {
  type = set(object({
    name                        = string
    # The Type of Routing that should be used for this Rule. Possible values are Basic and PathBasedRouting.
    rule_type                   = string
    http_listener_name          = string
    # The Name of the Backend Address Pool which should be used for this Routing Rule. Cannot be set if redirect_configuration_name is set.
    backend_address_pool_name   = string
    # The Name of the Backend HTTP Settings Collection which should be used for this Routing Rule. Cannot be set if redirect_configuration_name is set.
    backend_http_settings_name  = string
    # The Name of the Redirect Configuration which should be used for this Routing Rule. Cannot be set if either backend_address_pool_name or backend_http_settings_name is set.
    redirect_configuration_name = string
    rewrite_rule_set_name       = string
    url_path_map_name           = string
    priority                    = number
  }))
  default = []
}

variable "sku" {
  type = set(object({
    # The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2.
    name     = string
    # The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2.
    tier     = string
    # The Capacity of the SKU to use for this Application Gateway. When using a V1 SKU this value must be between 1 and 32, and 1 to 125 for a V2 SKU. This property is optional if autoscale_configuration is set.
    capacity = number
  }))
  default = [
    {
      name     = "Standard_Small"
      tier     = "Standard"
      capacity = null
    }
  ]
}

variable "zones" {
  type        = list(string)
  description = "Specifies a list of Availability Zones in which this Application Gateway should be located."
  default     = []
}

variable "trusted_client_certificate" {
  type = set(object({
    name = string
    data = string
  }))
  default = []
}

variable "ssl_profile" {
  type = set(object({
    name                             = string
    trusted_client_certificate_names = string
    verify_client_cert_issuer_dn     = bool
    ssl_policy                       = set(object({
      # A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2. disabled_protocols cannot be set when policy_name or policy_type are set.
      disabled_protocols   = list(string)
      # The Type of the Policy. Possible values are Predefined and Custom.
      policy_type          = string
      # When using a policy_type of Predefined the following fields are supported
      policy_name          = string
      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
      cipher_suites        = list(string)
      # The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2.
      min_protocol_version = string
    }))
  }))
  default = []
}

variable "authentication_certificate" {
  type = set(object({
    name = string
    deta = string
  }))
  default = []
}

variable "trusted_root_certificate" {
  type = set(object({
    name                = string
    deta                = string
    # The Secret ID of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for the Key Vault to use this feature. Required if data is not set.
    key_vault_secret_id = string
  }))
  default = []
}

variable "ssl_policy" {
  type = set(object({
    # A list of SSL Protocols which should be disabled on this Application Gateway. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2. disabled_protocols cannot be set when policy_name or policy_type are set.
    disabled_protocols   = list(string)
    # The Type of the Policy. Possible values are Predefined and Custom.
    policy_type          = string
    # When using a policy_type of Predefined the following fields are supported
    policy_name          = string
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
    cipher_suites        = list(string)
    # The minimal TLS version. Possible values are TLSv1_0, TLSv1_1 and TLSv1_2.
    min_protocol_version = string
  }))
  default = []
}

variable "enable_http2" {
  type        = bool
  description = "Is HTTP2 enabled on the application gateway resource"
  default     = false
}

variable "force_firewall_policy_association" {
  type        = bool
  description = "Is the Firewall Policy associated with the Application Gateway?"
  default     = false
}

variable "probe" {
  type = set(object({
    # The Hostname used for this Probe. If the Application Gateway is configured for a single site, by default the Host name should be specified as ‘127.0.0.1’, unless otherwise configured in custom probe. Cannot be set if pick_host_name_from_backend_http_settings is set to true.
    host                                      = string
    interval                                  = number
    name                                      = string
    # The Protocol used for this Probe. Possible values are Http and Https.
    protocol                                  = string
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = number
    pick_host_name_from_backend_http_settings = string
    match                                     = set(object({
      body        = any
      status_code = list(number)
    }))
    minimum_servers = number
  }))
  default = []
}

variable "ssl_certificate" {
  type = set(object({
    name                = string
    data                = string
    password            = string
    # Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set.
    key_vault_secret_id = string
  }))
  default = []
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "url_path_map" {
  type = set(object({
    name                                = string
    default_backend_address_pool_name   = string
    default_backend_http_settings_name  = string
    default_redirect_configuration_name = string
    default_rewrite_rule_set_name       = string
    path_rule                           = set(object({
      name                        = string
      paths                       = list(string)
      backend_address_pool_name   = string
      backend_http_settings_name  = string
      redirect_configuration_name = string
      rewrite_rule_set_name       = string
      firewall_policy_id          = string
    }))
  }))
  default = []
}

variable "waf_configuration" {
  type = set(object({
    enabled             = bool
    # The Web Application Firewall Mode. Possible values are Detection and Prevention.
    firewall_mode       = string
    # The Type of the Rule Set used for this Web Application Firewall. Currently, only OWASP is supported.
    rule_set_type       = string
    # The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, 3.1, and 3.2.
    rule_set_version    = string
    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway
    disabled_rule_group = set(object({
      rule_group_name = string
      rules           = list(string)
    }))
    file_upload_limit_mb     = number
    request_body_check       = bool
    max_request_body_size_kb = number
    exclusion                = set(object({
      match_variable          = string
      # Operator which will be used to search in the variable content. Possible values are Contains, EndsWith, Equals, EqualsAny and StartsWith. If empty will exclude all traffic on this match_variable
      selector_match_operator = string
      # String value which will be used for the filter operation. If empty will exclude all traffic on this match_variable
      selector                = string
    }))
  }))
  default = []
}

variable "custom_error_configuration" {
  type = set(object({
    # Status code of the application gateway customer error. Possible values are HttpStatus403 and HttpStatus502
    status_code           = string
    custom_error_page_url = string
  }))
  default = []
}

variable "firewall_policy_id" {
  type        = string
  description = "The ID of the Web Application Firewall Policy."
  default     = null
}

variable "redirect_configuration" {
  type = set(object({
    name                 = string
    # The type of redirect. Possible values are Permanent, Temporary, Found and SeeOther
    redirect_type        = string
    # One of target_listener_name or target_url
    target_listener_name = string
    target_url           = string
    include_path         = bool
    include_query_string = bool
  }))
  default = []
}

variable "autoscale_configuration" {
  type = set(object({
    min_capacity = number
    max_capacity = number
  }))
  default = []
}

variable "rewrite_rule_set" {
  type = set(object({
    name         = string
    rewrite_rule = set(object({
      name          = string
      rule_sequence = number
      condition     = set(object({
        variable    = string
        pattern     = string
        ignore_case = bool
        negate      = bool
      }))
      request_header_configuration = set(object({
        header_name  = string
        header_value = any
      }))
      response_header_configuration = set(object({
        header_name  = string
        header_value = any
      }))
      url = set(object({
        path         = string
        query_string = string
        # The components used to rewrite the URL. Possible values are path_only and query_string_only to limit the rewrite to the URL Path or URL Query String only.
        components   = string
        reroute      = string
      }))
    }))
  }))
  default = []
}