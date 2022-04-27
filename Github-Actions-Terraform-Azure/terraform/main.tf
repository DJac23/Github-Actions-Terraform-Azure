terraform {
  backend "azurerm" {
    resource_group_name  = "new-grp"
    storage_account_name = "terraformstate2162022"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}
#Add Git Repo block

#Pre-Existing resources
data "azurerm_resource_group" "name" {
    name = "New-grp"
}

data "azurerm_virtual_network" "vnet" {
    name = "vnet-01"
    resource_group_name = var.rgname
}

data "azurerm_subnet" "subnet" {
    name =   "pls-subnet"
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    resource_group_name = data.azurerm_resource_group.name.name
}

data "azurerm_subnet" "subnet1" {
    name = "fe-subnet"
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    resource_group_name  = data.azurerm_resource_group.name.name  
}

data "azurerm_mssql_server" "sqlserver" {
    name = "dbtestserver-01"
    resource_group_name = var.rgname
  
}

#Creating ADF and Synapse Workspace

resource "azurerm_data_factory" "demoadfname" {
    name = var.demoadfname
    location = var.location
    resource_group_name = var.rgname
    managed_virtual_network_enabled = var.managed_virtual_network_enabled ? "true" : "false"
    dynamic "github_configuration"{
      for_each = var.environment == "dev" ? [1] : []
      content{
        account_name = "djac23"
        branch_name = "test"
        repository_name = "Github-Actions-Terraform-Azure"
        root_folder = "/"
        git_url = "https://github.com"
      }
    }
  
}

resource "azurerm_data_factory_integration_runtime_azure" "managedIR" {
    name = var.managedIRname
    data_factory_id = azurerm_data_factory.demoadfname.id
    resource_group_name = var.rgname
    location = var.location
    virtual_network_enabled = var.virtual_network_enabled ? "true" : "false"
  
}

resource "azurerm_storage_account" "sname" {
  name                     = var.sname
  resource_group_name      = data.azurerm_resource_group.name.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true" #enables Hierarchical Namespace(used for data lake storages)
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dev-dlake-filesys" {
  name               = var.dev-dlake-filesys-name
  storage_account_id = azurerm_storage_account.sname.id
}

resource "azurerm_synapse_workspace" "dev-synwks-001" {
  name                                 =  var.azurerm_synapse_workspace_name
  resource_group_name                  = data.azurerm_resource_group.name.name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dev-dlake-filesys.id
  sql_administrator_login              = var.admin_username
  sql_administrator_login_password     = var.admin_password 
  managed_virtual_network_enabled = var.managed_virtual_network_enabled ? "true" : "false"
  data_exfiltration_protection_enabled = var.data_exfiltration_protection_enabled ? "true" : "false" #securing data egress from synapse workspace

  aad_admin {
    login     = var.aad_admin_login
    object_id = var.object_id
    tenant_id = var.tenant_id
  }

  tags = "${var.tags[0]}"
}

# ADF Azure to Azure Manage Endpoints
resource "azurerm_data_factory_managed_private_endpoint" "SQLDB" {
    name = var.SQLDBName
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = data.azurerm_mssql_server.sqlserver.id 
    subresource_name = "sqlServer"  
}

resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-blob" {
    name = var.syndatalake-blob-name
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = azurerm_storage_account.sname.id
    subresource_name = "blob"  
}

resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-table" {
    name = var.syndatalake-table-name
    data_factory_id = azurerm_data_factory.demoadfname.id
    target_resource_id = azurerm_storage_account.sname.id
    subresource_name = "table"  
}

# #Creating  LB

# resource "azurerm_lb" "internalLB" {
#   name                = "myLoadBalancer"
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.name.name
#   sku                 = "Standard"
  

#   frontend_ip_configuration {
#     name                 = "LoadBalancerFrontEnd"
#     zones                =  "Zone-redundant"
#     subnet_id            = data.azurerm_subnet.subnet1.id
#     private_ip_address_allocation = "Dynamic"
#     private_ip_address_version    =  "IPv4"
  
#   }
# }

# resource "azurerm_lb_backend_address_pool" "myBackendPool" {
#   loadbalancer_id = azurerm_lb.internalLB.id
#   name            = "myBackendPool"

#   # tunnel_interface {
    
#   # }
# }
# resource "azurerm_lb_probe" "myHealthProbe" {
#   loadbalancer_id = azurerm_lb.internalLB.id
#   name            = "myHealthProbe"
#   port            = 22
#   interval_in_seconds = 15
# }

