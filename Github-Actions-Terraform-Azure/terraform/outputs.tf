# output "rg_name" {
#   value = {
#     appname = module.RG.resourcegroup_name.rg_name
#   }
# }
output "adf_id" {
  value = data.azurerm_data_factory.adf.id
}

output "subnet_id" {
  value = data.azurerm_subnet.subnet.id
}

output "rg_id" {
  value = data.azurerm_resource_group.name.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}