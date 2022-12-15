resource "azurerm_network_ddos_protection_plan" "plan" {
  count               = var.ddos_plan_enabled ? 1 : 0
  name                = var.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  tags                = {}
}

resource "azurerm_public_ip_prefix" "prefix" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  name                = var.name
  sku                 = "Standard"
  ip_version          = "IPv4"
  prefix_length       = 31
  tags                = {}
  zones               = []
}

resource "azurerm_public_ip" "ip" {
  resource_group_name     = data.azurerm_resource_group.resource_group.name
  location                = data.azurerm_resource_group.resource_group.location
  name                    = var.name
  allocation_method       = "Static"
  zones                   = azurerm_public_ip_prefix.prefix.zones
  domain_name_label       = null
  edge_zone               = null
  idle_timeout_in_minutes = 30
  ip_tags                 = {}
  public_ip_prefix_id     = azurerm_public_ip_prefix.prefix.id
  reverse_fqdn            = null
  sku                     = azurerm_public_ip_prefix.prefix.sku
  sku_tier                = "Regional"
  tags                    = {}
}

locals {
  backend_address_pool       = "${var.name}-backend-address-pool"
  backend_http_settings      = "${var.name}-backend-http-settings"
  frontend_ip_configuration  = "${var.name}-frontend-ip-configuration"
  frontend_port              = "${var.name}-frontend-port"
  http_listener              = "${var.name}-http-listener"
  request_routing_rule       = "${var.name}-request-routing-rule"
  redirect_configuration     = "${var.name}-redirect-configuration"
  rewrite_rule_set           = "${var.name}-rewrite-rule-set"
  url_path_map               = "${var.name}-url-path-map"
  probe                      = "${var.name}-probe"
  private_link_configuration = "${var.name}-private-link-configuration"
}

resource "azurerm_application_gateway" "gateway" {
  resource_group_name               = data.azurerm_resource_group.resource_group.name
  location                          = data.azurerm_resource_group.resource_group.location
  name                              = var.name
  fips_enabled                      = var.fips_enabled
  enable_http2                      = var.enable_http2
  force_firewall_policy_association = var.force_firewall_policy_association
  firewall_policy_id                = var.firewall_policy_id
  tags                              = var.tags

  dynamic "sku" {
    for_each = var.sku
    content {
      name     = sku.value.name
      tier     = sku.value.tier
      capacity = sku.value.capacity
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = var.gateway_ip_configuration
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name                            = local.frontend_ip_configuration
      subnet_id                       = frontend_ip_configuration.value.subnet_id
      private_ip_address              = frontend_ip_configuration.value.private_ip_address
      public_ip_address_id            = azurerm_public_ip.ip.id
      private_ip_address_allocation   = frontend_ip_configuration.value.private_ip_address_allocation
      private_link_configuration_name = local.private_link_configuration
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = local.frontend_port
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name         = local.backend_address_pool
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {

      dynamic "authentication_certificate" {
        for_each = toset(backend_http_settings.value.authentication_certificate)
        content {
          name = authentication_certificate.value.name
        }
      }

      name                                = local.backend_http_settings
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      probe_name                          = local.probe
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      host_name                           = backend_http_settings.value.host_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = backend_http_settings.value.trusted_root_certificate_names

      dynamic "connection_draining" {
        for_each = toset(backend_http_settings.value.connection_draining)
        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
        }
      }
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = local.http_listener
      frontend_ip_configuration_name = local.frontend_ip_configuration
      frontend_port_name             = local.frontend_port
      host_name                      = http_listener.value.host_name
      host_names                     = http_listener.value.host_names
      protocol                       = http_listener.value.protocol
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name

      dynamic "custom_error_configuration" {
        for_each = toset(http_listener.value.custom_error_configuration)
        content {
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
          status_code           = custom_error_configuration.value.status_code
        }
      }

      firewall_policy_id = http_listener.value.firewall_policy_id
      ssl_profile_name   = http_listener.value.ssl_profile_name
    }
  }

  # Global?

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "private_link_configuration" {
    for_each = var.private_link_configuration
    content {
      name = local.private_link_configuration
      dynamic "ip_configuration" {
        for_each = private_link_configuration.value.ip_configuration
        content {
          name                          = ip_configuration.value.name
          subnet_id                     = ip_configuration.value.subnet_id
          private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
          primary                       = ip_configuration.value.primary
          private_ip_address            = ip_configuration.value.private_ip_address
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule
    content {
      name                       = local.request_routing_rule
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = local.http_listener
      backend_address_pool_name  = local.backend_address_pool
      backend_http_settings_name = local.backend_http_settings
      # redirect_configuration_name = local.redirect_configuration
      rewrite_rule_set_name      = local.rewrite_rule_set
      url_path_map_name          = local.url_path_map
      priority                   = request_routing_rule.value.priority
    }
  }

  # Zones?

  dynamic "trusted_client_certificate" {
    for_each = var.trusted_client_certificate
    content {
      name = trusted_client_certificate.value.name
      data = trusted_client_certificate.value.data
    }
  }

  dynamic "ssl_profile" {
    for_each = var.ssl_profile
    content {
      name                             = ssl_profile.value.name
      trusted_client_certificate_names = ssl_profile.value.trusted_client_certificate_names
      verify_client_cert_issuer_dn     = ssl_profile.value.verify_client_cert_issuer_dn

      dynamic "ssl_policy" {
        for_each = ssl_profile.value.ssl_policy
        content {
          disabled_protocols   = ssl_policy.value.disabled_protocols
          policy_type          = ssl_policy.value.policy_type
          policy_name          = ssl_policy.value.policy_name
          cipher_suites        = ssl_policy.value.cipher_suites
          min_protocol_version = ssl_policy.value.min_protocol_version
        }
      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificate
    content {
      name = authentication_certificate.value.name
      data = authentication_certificate.value.data
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificate
    content {
      name                = trusted_root_certificate.value.name
      data                = trusted_root_certificate.value.data
      key_vault_secret_id = trusted_root_certificate.value.key_vault_secret_id
    }
  }

  dynamic "ssl_policy" {
    for_each = var.ssl_policy
    content {
      disabled_protocols   = ssl_policy.value.disabled_protocols
      policy_type          = ssl_policy.value.policy_type
      policy_name          = ssl_policy.value.policy_name
      cipher_suites        = ssl_policy.value.cipher_suites
      min_protocol_version = ssl_policy.value.min_protocol_version
    }
  }


  dynamic "probe" {
    for_each = var.probe
    content {
      name                                      = local.probe
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = probe.value.port
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings

      dynamic "match" {
        for_each = probe.value.match
        content {
          body        = match.value.body
          status_code = match.value.status_code
        }
      }

      minimum_servers = probe.value.minimum_servers
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate
    content {
      name                = ssl_certificate.value.name
      data                = ssl_certificate.value.data
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                                = local.url_path_map
      default_backend_address_pool_name   = local.backend_address_pool
      default_backend_http_settings_name  = local.backend_http_settings
      default_redirect_configuration_name = local.redirect_configuration
      default_rewrite_rule_set_name       = local.rewrite_rule_set

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule
        content {
          name                        = path_rule.value.name
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
          redirect_configuration_name = path_rule.value.redirect_configuration
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
          firewall_policy_id          = path_rule.value.firewall_policy_id
        }
      }
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration
    content {
      enabled          = waf_configuration.value.enabled
      firewall_mode    = waf_configuration.value.firewall_mode
      rule_set_type    = waf_configuration.value.rule_set_type
      rule_set_version = waf_configuration.value.rule_set_version

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }

      file_upload_limit_mb     = waf_configuration.value.file_upload_limit_mb
      request_body_check       = waf_configuration.value.request_body_check
      max_request_body_size_kb = waf_configuration.value.max_request_body_size_kb

      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion
        content {
          match_variable          = exclusion.value.match_variable
          selector_match_operator = exclusion.value.selector_match_operator
          selector                = exclusion.value.selector
        }
      }
    }
  }

  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration
    content {
      custom_error_page_url = custom_error_configuration.value.custom_error_page_url
      status_code           = custom_error_configuration.value.status_code
    }
  }

  dynamic redirect_configuration {
    for_each = var.redirect_configuration
    content {
      name          = local.redirect_configuration
      redirect_type = redirect_configuration.value.redirect_type
    }
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_set
    content {
      name = local.rewrite_rule_set

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rule
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.condition
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configuration
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }
          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configuration
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value
            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value.url
            content {
              path         = url.value.path
              query_string = url.value.query_string
              #              components   = url.value.components
              reroute      = url.value.reroute
            }
          }
        }
      }
    }
  }
}