variable "ingress" {
  type = set(object({

    metadata = set(object({
      annotations = map(string)
      name        = string
      labels      = string
    }))

    spec = set(object({
      rule = set(object({
        host = string
        http = set(object({
          path = set(object({
            path    = string
            backend = set(object({
              service_name = string
              service_port = string
            }))
          }))
        }))
        tls = set(object({
          secret_name = string
        }))
      }))
    }))

    wait_for_load_balancer = bool
  }))
  description = "Ingress is a collection of rules that allow inbound connections to reach the endpoints defined by a backend. An Ingress can be configured to give services externally-reachable urls, load balance traffic, terminate SSL, offer name based virtual hosting etc."
  default     = []
}
