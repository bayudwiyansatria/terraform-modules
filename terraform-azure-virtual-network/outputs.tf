output "id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet" {
  value = [
    for i in azurerm_subnet.subnet : {
      id   = i.id
      name = i.name
    }
  ]
}