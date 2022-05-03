# # output "rg_name" {
# #   value = {
# #     appname = module.RG.resourcegroup_name.rg_name
# #   }
# # }
# # output "adf_id" {
# #   value = data.azurerm_data_factory.adf.id
# # }

output "subnet_id" {
  value = data.azurerm_subnet.subnet.id
}

output "subnet_id_01" {
  value = data.azurerm_subnet.subnet1.id
}

output "rg_id" {
  value = data.azurerm_resource_group.name.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet.id
}

# output "sql_server_id" {
#   value = data.azurerm_mssql_server.sqlserver.id
# }


output "subnet_id_02" {
  value = data.azurerm_subnet.subnet2.id
}