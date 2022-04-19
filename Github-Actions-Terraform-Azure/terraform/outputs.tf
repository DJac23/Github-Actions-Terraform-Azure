# output "rg_name" {
#   value = {
#     appname = module.RG.resourcegroup_name.rg_name
#   }
# }
output "id" {
  value = data.azurerm_data_factory.example.id
}

output "subnet_id" {
  value = data.azurerm_subnet.example.id
}

output "id" {
  value = data.azurerm_resource_group.example.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.example.id
}