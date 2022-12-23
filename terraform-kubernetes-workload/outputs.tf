output "name" {
  value = {
    deployment = kubernetes_deployment.apps.metadata.0.name
    service    = [
      for i in kubernetes_service.service : i.metadata.0.name
    ]
    config = [
      for i in kubernetes_config_map.config : i.metadata.0.name
    ]
    secret = [
      for i in kubernetes_secret.secret : i.metadata.0.name
    ]
  }
}
