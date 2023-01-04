resource "kubernetes_cluster_role" "role" {
  dynamic "metadata" {
    for_each = var.metadata
    content {
      annotations = metadata.value.annotations
      name        = metadata.value.name
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      api_groups        = rule.value.api_groups
      non_resource_urls = rule.value.non_resource_urls
      resource_names    = rule.value.resource_names
      resources         = rule.value.resources
      verbs             = rule.value.verbs
    }
  }

  dynamic "aggregation_rule" {
    for_each = var.aggregation_rules

    content {

      dynamic "cluster_role_selectors" {
        for_each = aggregation_rule.value.cluster_role_selectors

        content {
          match_labels = cluster_role_selectors.value.match_labels

          dynamic "match_expressions" {
            for_each = cluster_role_selectors.value.match_expressions
            content {
              key      = match_expressions.value.key
              operator = match_expressions.value.operator
              values   = match_expressions.value.values
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_cluster_role_binding" "binding" {
  dynamic "metadata" {
    for_each = var.metadata
    content {
      annotations = metadata.value.annotations
      name        = metadata.value.name
    }
  }

  dynamic "role_ref" {
    for_each = var.roles_ref
    content {
      api_group = role_ref.value.api_group
      kind      = role_ref.value.kind
      name      = role_ref.value.name
    }
  }

  dynamic "subject" {
    for_each = var.subjects
    content {
      kind      = subject.value.kind
      name      = subject.value.name
      api_group = subject.value.api_group
      namespace = subject.value.namespace
    }
  }
}

