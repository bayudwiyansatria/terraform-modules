variable "metadata" {
  type = set(object({
    annotations = map(string)
    name        = string
    namespace   = string
  }))
}

variable "rules" {
  type = set(object({
    api_groups        = list(string)
    non_resource_urls = list(string)
    resource_names    = list(string)
    resources         = list(string)
    verbs             = list(string)
  }))
}

variable "aggregation_rules" {
  type = set(object({
    cluster_role_selectors = set(object({
      match_expressions = set(object({
        key      = string
        operator = string
        values   = list(string)
      }))
      match_labels = map(string)
    }))
  }))
}

variable "roles_ref" {
  type = set(object({
    api_group = string
    kind      = string
    name      = string
  }))
  default = [
    {
      api_group = "rbac.authorization.k8s.io"
      kind      = "ClusterRole"
      name      = "cluster-admin"
    }
  ]
}

variable "subjects" {
  type = set(object({
    kind      = string
    name      = string
    api_group = string
    namespace = string
  }))
  default = [
    {
      kind      = "ServiceAccount"
      name      = "admin"
      api_group = ""
      namespace = "kube-system"
    }
  ]
}
