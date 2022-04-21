terraform {
  backend "azurerm" {
    resource_group_name  = "new-grp"
    storage_account_name = "terraformstate2162022"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}

 #module "RG" {
 # source   = "./modules/RG" #A
 # rgname   = var.rgname     
 # location = var.location
#}

# data "azurerm_resource_group" "name" {
#     name = "New-grp"
# }

# data "azurerm_data_factory" "adf" {
#     name = "man-adf-poc"
#     resource_group_name = var.rgname
# }

# data "azurerm_virtual_network" "vnet" {
#     name = "vnet-01"
#     resource_group_name = var.rgname
# }

# data "azurerm_subnet" "subnet" {
#     name =   "priv-endpoints"
#     virtual_network_name = data.azurerm_virtual_network.vnet.name
#     resource_group_name = var.rgname
# }

# data "azurerm_mssql_server" "sqlserver" {
#     name = "dbtestserver-01"
#     resource_group_name = var.rgname
  
# }

# resource "azurerm_data_factory" "demoadfname" {
#     name = var.demoadfname
#     location = var.location
#     resource_group_name = var.rgname
#     managed_virtual_network_enabled = true
  
# }

# resource "azurerm_data_factory_integration_runtime_azure" "managedIR" {
#     name = "managedIR"
#     data_factory_id = azurerm_data_factory.demoadfname.id
#     resource_group_name = var.rgname
#     location = var.location
#     virtual_network_enabled = true
  
# }

# resource "azurerm_data_factory_managed_private_endpoint" "SQLDB" {
#     name = "SQLDB"
#     data_factory_id = azurerm_data_factory.demoadfname.id
#     target_resource_id = data.azurerm_mssql_server.sqlserver.id 
#     subresource_name = "sqlServer"  
# }

# resource "azurerm_private_endpoint" "SQL_DB" {
#     name = "sql_db"
#     location = data.azurerm_resource_group.name.location
#     resource_group_name = data.azurerm_resource_group.name.name
#     subnet_id = data.azurerm_subnet.subnet.id

#     private_service_connection {
#       name = "sql-privateserviceconnection"
#       subresource_names = [ "sqlServer" ]
#       private_connection_resource_id = data.azurerm_mssql_server.sqlserver.id
#       is_manual_connection = false
#     }
  
#}


# resource "azurerm_data_factory_integration_runtime_managed" "managedIR" {
#     name = "managedIR"
#     data_factory_name = azurerm_data_factory.demoadfname.name
#    # data_factory_id = data.azurerm_data_factory.adf.id
#     location = var.location
#     resource_group_name = var.rgname

#     node_size = "Standard_D8_v3"
#     vnet_integration {
#       vnet_id = data.azurerm_virtual_network.vnet.id
#       subnet_name = data.azurerm_subnet.subnet.name
#     }
  
# }



# resource "azurerm_virtual_network" "github-action" {
#   name                = "github-action-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rgname.location
#   resource_group_name = azurerm_resource_group.rgname.name
# }
# resource "azurerm_subnet" "github-action" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.rgname.name
#   virtual_network_name = azurerm_virtual_network.github-action.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_network_interface" "github-action" {
#   name                = "github-action-nic"
#   location            = azurerm_resource_group.rgname.location
#   resource_group_name = azurerm_resource_group.github-action.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.rgname.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }
# resource "azurerm_windows_virtual_machine" "github-action" {
#   name                = "github-action-machine"
#   resource_group_name = azurerm_resource_group.rgname.name
#   location            = azurerm_resource_group.rgname.location
#   size                = "Standard_F2"
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   network_interface_ids = [
#     azurerm_network_interface.rgname.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }
# }
#module "SA" {
 # source   = "./modules/StorageAccount"
 # sname    = var.sname
 # rgname   = var.rgname
 # location = var.location
#}
