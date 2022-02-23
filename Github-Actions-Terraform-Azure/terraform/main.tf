terraform {
  backend "azurerm" {
    resource_group_name  = "new-grp"
    storage_account_name = "terraformstate2162022"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}
module "RG" {
  source   = "./modules/RG" #A
  rgname   = var.rgname     
  location = var.location
}
resource "azurerm_virtual_network" "github-action" {
  name                = "github-action-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = module.RG.resourcegroup_name.rg_name
}
resource "azurerm_subnet" "github-action" {
  name                 = "internal"
  resource_group_name  = module.RG.resourcegroup_name.rg_name
  virtual_network_name = azurerm_virtual_network.github-action.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "github-action" {
  name                = "github-action-nic"
  location            = var.location
  resource_group_name = module.RG.resourcegroup_name.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.github-action.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "github-action" {
  name                = "github-action"
  resource_group_name = module.RG.resourcegroup_name.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.github-action.id,
  ]

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
module "SA" {
  source   = "./modules/StorageAccount"
  sname    = var.sname
  rgname   = module.RG.resourcegroup_name.rg_name
  location = var.location
}
