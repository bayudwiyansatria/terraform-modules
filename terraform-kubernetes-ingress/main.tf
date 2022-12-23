resource "kubernetes_ingress" "ingress" {
  for_each = {
    for k, v in toset(var.ingress) : toset(v.metadata).0.name => k
  }

  dynamic "metadata" {
    for_each = {
      for k, v in toset(each.value.metadata) : v.name => k
    }
    content {
      name = metadata.value.name
    }
  }

  dynamic "spec" {
    for_each = {
      for k, v in toset(each.value.spec) : v.name => k
    }
    content {

      dynamic "rule" {
        for_each = toset(spec.value.rule)
        content {
          host = rule.value.host

          dynamic "http" {
            for_each = toset(rule.value.http)
            content {

              dynamic "path" {
                for_each = http.value.path
                content {

                  path = path.value.path
                  dynamic "backend" {
                    for_each = path.value.backend
                    content {
                      service_name = backend.value.service_name
                      service_port = backend.value.service_port
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "tls" {
        for_each = toset(spec.value.tls)
        content {
          secret_name = tls.value.secret_name
        }
      }
    }
  }
}
