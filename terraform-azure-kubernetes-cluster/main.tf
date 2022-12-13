data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  dns_prefix          = var.cluster_name

  dynamic "default_node_pool" {
    for_each = var.node_pool
    content {
      name       = default_node_pool.value.name
      node_count = default_node_pool.value.node_count
      vm_size    = default_node_pool.value.vm_size
    }
  }

  dynamic identity {
    for_each = var.identity
    content {
      type = identity.value.type
    }
  }
}