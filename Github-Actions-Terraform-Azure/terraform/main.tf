terraform {
  backend "azurerm" {
    resource_group_name  = "1-34faef06-playground-sandbox"
    storage_account_name = "terraformstate216202"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}

# module "RG" {
#   source   = "./modules/RG" #A
#   rgname   = var.rgname     
#   location = var.location
# }
data "azurerm_resource_group" "name" {
  name = "1-34faef06-playground-sandbox"
  
}

resource "azurerm_virtual_network" "github-action" {
  name                = "github-action-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.name
}

resource "azurerm_subnet" "github-action-subnet" {
  name                 = "var.subnet_name-${count.index}"
  resource_group_name  = data.azurerm_resource_group.name
  virtual_network_name = azurerm_virtual_network.github-action.name
  address_prefixes     = [var.address_prefixes[count.index]]
  count = "${length(var.subnet_name)}"

}

resource "azurerm_network_interface" "github-action-nic" {
  name                = "github-action-nic-${count.index}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.name
  count = 2
  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.github-action-subnet[count.index].id}"
    private_ip_address_allocation = "Dynamic"
  }
  
  tags = {
    name = "github-action-nic-${count.index}"
    Env = "Dev"    
}

}
resource "azurerm_windows_virtual_machine" "github-action" {
  name                = "github-action-${count.index}"
  resource_group_name = data.azurerm_resource_group.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  count = 2
  network_interface_ids = [
    "${azurerm_network_interface.github-action-nic[count.index].id}"
  ]

  tags = {
    name = "github-action-${count.index}"
    Env = "Dev"
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# module "SA" {
#   source   = "./modules/StorageAccount"
#   sname    = var.sname
#   rgname   = var.rgname
#   location = var.location
# }
