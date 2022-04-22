terraform {
  backend "azurerm" {
    resource_group_name  = "new-grp"
    storage_account_name = "terraformstate2162022"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}


data "azurerm_resource_group" "name" {
    name = "New-grp"
}

data "azurerm_virtual_network" "vnet" {
    name = "vnet-01"
    resource_group_name = var.rgname
}

# data "azurerm_subnet" "subnet" {
#     name =   "priv-endpoints"
#     virtual_network_name = data.azurerm_virtual_network.vnet.name
#     resource_group_name = var.rgname
# }

data "azurerm_mssql_server" "sqlserver" {
    name = "dbtestserver-01"
    resource_group_name = var.rgname
  
}

#Creating ADF and Synapse Workspace

resource "azurerm_data_factory" "demoadfname" {
    name = var.demoadfname
    location = var.location
    resource_group_name = var.rgname
    managed_virtual_network_enabled = true
  
}

resource "azurerm_data_factory_integration_runtime_azure" "managedIR" {
    name = "managedIR"
    data_factory_id = azurerm_data_factory.demoadfname.id
    resource_group_name = var.rgname
    location = var.location
    virtual_network_enabled = true
  
}

resource "azurerm_storage_account" "sname" {
  name                     = var.sname
  resource_group_name      = data.azurerm_resource_group.name.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dev-dlake-filesys" {
  name               = "dev-dlake-filesys"
  storage_account_id = azurerm_storage_account.sname.id
}

resource "azurerm_synapse_workspace" "dev-synwks-001" {
  name                                 = "dev-synwks-001"
  resource_group_name                  = data.azurerm_resource_group.name.name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dev-dlake-filesys.id
  sql_administrator_login              = var.admin_username
  sql_administrator_login_password     = var.admin_password 
  managed_virtual_network_enabled = true
  data_exfiltration_protection_enabled = true

  aad_admin {
    login     = "AzureAD Admin"
    object_id = var.object_id
    tenant_id = var.tenant_id
  }

  tags = {
    Env = "dev"
  }
}


#ADF Azure to Azure Manage Endpoints
resource "azurerm_data_factory_managed_private_endpoint" "SQLDB" {
    name = "SQLDB"
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = data.azurerm_mssql_server.sqlserver.id 
    subresource_name = "sqlServer"  
}

resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-blob" {
    name = "syndatalake"
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = azurerm_storage_account.sname.id
    # subsubresource_name = "blob"  
}

resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-table" {
    name = "syndatalake"
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = azurerm_storage_account.sname.id
    # subsubresource_name = "table"  
}