terraform {
  backend "azurerm" {
    resource_group_name  = "new-grp"
    storage_account_name = "terraformstate2162022"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}


# #Pre-Existing resources
data "azurerm_resource_group" "name" {
    name = "New-grp"
}

data "azurerm_virtual_network" "vnet" {
    name = "vnet-01"
    resource_group_name = var.rgname
}

# data "azurerm_subnet" "subnet" {
#     name =   "pls-subnet"
#     virtual_network_name = data.azurerm_virtual_network.vnet.name
#     resource_group_name = azurerm_resource_group.rgname.name
# }

# data "azurerm_subnet" "subnet1" {
#     name = "fe-subnet"
#     virtual_network_name = data.azurerm_virtual_network.vnet.name
#     resource_group_name  = azurerm_resource_group.rgname.name  
# }

# data "azurerm_subnet" "subnet2" {
#     name = "be-subnet"
#     virtual_network_name = data.azurerm_virtual_network.vnet.name
#     resource_group_name  = azurerm_resource_group.rgname.name  
# }

# # data "azurerm_mssql_server" "sqlserver" {
# #     name = "dbtestserver-01"
# #     resource_group_name = var.rgname  
# # }



# # #Creating ADF 

resource "azurerm_data_factory" "demoadfname" {
    # count = "${var.environment == "dev" && var.managed_virtual_network_enabled && var.virtual_network_enabled ? 1 : 0}
    name = var.demoadfname
    location = var.location
    resource_group_name = var.rgname
    managed_virtual_network_enabled = var.managed_virtual_network_enabled ? "true" : "false"
    public_network_enabled = false
}    
# #     dynamic "github_configuration"{
# #       for_each = var.environment == "dev" ? [1] : []
# #       content{
# #         account_name = "djac23"
# #         branch_name = "main"
# #         repository_name = "Github-Actions-Terraform-Azure"
# #         root_folder = "/"
# #         git_url = "https://github.com"
# #       }
# #     }  


resource "azurerm_data_factory_integration_runtime_azure" "managedIR" {
    name = var.managedIRname
    data_factory_id = azurerm_data_factory.demoadfname.id
    resource_group_name = var.rgname
    location = var.location
    virtual_network_enabled = var.virtual_network_enabled ? "true" : "false"    
  
}

# # # resource "azurerm_storage_account" "sname" {
# # #   name                     = var.sname
# # #   resource_group_name      = azurerm_resource_group.rgname.name
# # #   location                 = var.location
# # #   account_tier             = "Standard"
# # #   account_replication_type = "LRS"
# # #   account_kind             = "StorageV2"
# # #   is_hns_enabled           = "true" #enables Hierarchical Namespace(used for data lake storages)
# # #   allow_blob_public_access = false
# # # }

# # # resource "azurerm_storage_data_lake_gen2_filesystem" "dev-dlake-filesys" {
# # #   name               = var.dev-dlake-filesys-name
# # #   storage_account_id = azurerm_storage_account.sname.id
# # # }

# # # resource "azurerm_synapse_workspace" "dev-synwks-001" {
# # #   name                                 =  var.azurerm_synapse_workspace_name
# # #   resource_group_name                  = azurerm_resource_group.rgname.name
# # #   location                             = var.location
# # #   storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dev-dlake-filesys.id
# # #   sql_administrator_login              = var.admin_username
# # #   sql_administrator_login_password     = var.admin_password 
# # #   managed_virtual_network_enabled = var.managed_virtual_network_enabled ? "true" : "false"
# # #   data_exfiltration_protection_enabled = var.data_exfiltration_protection_enabled ? "true" : "false" #securing data egress from synapse workspace

# # #   aad_admin {
# # #     login     = var.aad_admin_login
# # #     object_id = var.object_id
# # #     tenant_id = var.tenant_id
# # #   }

# # #   tags = {
# # #       environment = "${var.tags[0]}"
# # #   }
# # # }

# # # ADF Azure to Azure Manage Endpoints
# # resource "azurerm_data_factory_managed_private_endpoint" "SQLDB" {
# #     name = var.SQLDBName
# #     data_factory_id = azurerm_data_factory.demoadfname.id
# #     target_resource_id = data.azurerm_mssql_server.sqlserver.id 
# #     subresource_name = "sqlServer"  
# # }

# # resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-blob" {
# #     name = var.syndatalake-blob-name
# #     data_factory_id = azurerm_data_factory.demoadfname.id
# #     target_resource_id = azurerm_storage_account.sname.id
# #     subresource_name = "blob"  
# # }

# # resource "azurerm_data_factory_managed_private_endpoint" "syndatalake-table" {
# #     name = var.syndatalake-table-name
# #     data_factory_id = azurerm_data_factory.demoadfname.id
# #     target_resource_id = azurerm_storage_account.sname.id
# #     subresource_name = "table"  
# # }

# # resource "azurerm_data_factory_managed_private_endpoint" "plsconnection" {
# #    name = "plsconnection"
# #    data_factory_id = azurerm_data_factory.demoadfname.id
# #    target_resource_id = azurerm_private_link_service.pls.id
# # }

# # resource "azurerm_resource_group" "rgname" {
# #    name     = var.rgname
# #    location = var.location
# #  }

# #  resource "azurerm_virtual_network" "vnetname" {
# #    name                = var.vnetname
# #    address_space       = ["10.0.0.0/16"] #Example IP range,please change to desired ip range
# #    location            = var.location
# #    resource_group_name = azurerm_resource_group.rgname.name
# #  }

# #  resource "azurerm_subnet" "frontendsubnet" {
# #    name                 = var.frontendsubnetname
# #    resource_group_name  = azurerm_resource_group.rgname.name
# #    virtual_network_name = azurerm_virtual_network.vnetname.name
# #    address_prefixes     = ["10.0.2.0/24"] #Example IP range,please change to desired ip range
# #  }

# #   resource "azurerm_subnet" "backendsubnet" {
# #    name                 = var.BackendServersName
# #    resource_group_name  = azurerm_resource_group.rgname.name
# #    virtual_network_name = azurerm_virtual_network.vnetname.name
# #    address_prefixes     = ["10.0.3.0/24"] #Example IP range,please change to desired ip range
# #  }

# #    resource "azurerm_subnet" "privlinksubnet" {
# #    name                 = var.privlinksubnet
# #    resource_group_name  = azurerm_resource_group.rgname.name
# #    virtual_network_name = azurerm_virtual_network.vnetname.name
# #    address_prefixes     = ["10.0.4.0/24"] #Example IP range,please change to desired ip range
# #  }


# # # #Creating  LB

# resource "azurerm_lb" "internalLB" {
#   name                = var.lbname
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rgname.name
#   sku                 = "Standard"
  

#   frontend_ip_configuration {
#     name                 = "LoadBalancerFrontEnd"
#     # zones                =  "Zone-redundant"
#     subnet_id            = azurerm_subnet.frontendsubnet
#     private_ip_address_allocation = "Dynamic"
#     private_ip_address_version    =  "IPv4"
  
#   }
# }

# resource "azurerm_lb_backend_address_pool" "myBackendPool" {
#   loadbalancer_id = azurerm_lb.internalLB.id
#   name            = "myBackendPool"
# }

# resource "azurerm_lb_probe" "myHealthProbe" {
#   loadbalancer_id = azurerm_lb.internalLB.id
#   resource_group_name = azurerm_resource_group.rgname.name
#   name            = "myHealthProbe"
#   port            = 22
#   interval_in_seconds = 15
# }

# resource "azurerm_lb_rule" "myRule" {
#   loadbalancer_id = azurerm_lb.internalLB.id
#   resource_group_name = azurerm_resource_group.rgname.name
#   name = "myRule"
#   protocol = "TCP"
#   frontend_port = 1433
#   backend_port = 1433
#   frontend_ip_configuration_name = "LoadBalancerFrontEnd"
#   backend_address_pool_ids = [azurerm_lb_backend_address_pool.myBackendPool.id]
#   probe_id = azurerm_lb_probe.myHealthProbe.id
  
# }

# #Associate VM with LB backend pool
# resource "azurerm_network_interface_backend_address_pool_association" "lb_backend" {
#     count = var.instance_count
#     network_interface_id = azurerm_network_interface.linux-vm-nic[count.index].id
#     ip_configuration_name = "internal"
#     backend_address_pool_id = azurerm_lb_backend_address_pool.myBackendPool.id
# }

# #Private link service setup
# resource "azurerm_private_link_service" "pls" {
#   name = var.pls_name
#   resource_group_name = azurerm_resource_group.rgname.name
#   location = var.location

#   auto_approval_subscription_ids = var.Sub_ID
#   visibility_subscription_ids = var.Sub_ID
#   load_balancer_frontend_ip_configuration_ids = [azurerm_lb.internalLB.frontend_ip_configuration[0].id]

#   nat_ip_configuration {
#     name = "myPrivateLinkService"
#     private_ip_address_version = "IPv4"
#     subnet_id = azurerm_subnet.privlinksubnet.id #Verify that the Subnet's "enforce_private_link_service_network_policies" attribute is set to false.
#     primary = true
#   }  
# }

# #Create Network Card for linux VM
# resource "azurerm_network_interface" "linux-vm-nic" {
#   count = var.instance_count
#   name = "linux-vm-nic-${count.index}"
#   location = var.location
#   resource_group_name = azurerm_resource_group.rgname.name

#   ip_configuration {
#     name = "internal"
#     subnet_id = azurerm_subnet.backendsubnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.myterraformpublicip.id
#   }  
# }

# # Create public IPs
# resource "azurerm_public_ip" "myterraformpublicip" {
#   name                = "myPublicIP"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rgname.name
#   allocation_method   = "Static"
# }

# # Create Network Security Group and rule
# resource "azurerm_network_security_group" "mylinuxsg" {
#   name                = "myNetworkSecurityGroup"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rgname.name

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }


# # Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# #create key local
# resource "local_file" "linuxkey" {
#   filename = "linuxkey.pem"
#   content = tls_private_key.example_ssh.private_key_pem
# }

# #creating Linux VM
# resource "azurerm_linux_virtual_machine" "linuxvm" {
#   count = var.instance_count
#   name = "linuxvm${count.index}"
#   resource_group_name = azurerm_resource_group.rgname.name
#   location = var.location
#   size = "Standard_D2s_v3"
#   network_interface_ids = [element(azurerm_network_interface.linux-vm-nic.*.id, count.index)]
#   admin_username = var.admin_username 
#   computer_name = "linuxvm${count.index}"
#   custom_data = filebase64("${path.module}/ip_forward.sh")

#   disable_password_authentication = true

#    os_disk {
#     name                 = "myOsDisk${count.index}"
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#   }
  
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "19.04"
#     version   = "latest"
#   }

#   admin_ssh_key {
#     username = var.admin_username
#     public_key = tls_private_key.example_ssh.public_key_openssh
#   }

#   depends_on = [
#     tls_private_key.example_ssh
#   ]
# }