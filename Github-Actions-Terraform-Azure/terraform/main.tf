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
resource "azurerm_subnet" "github-action-subnet" {
  subnet_name          = "${var.subnet_name}-${count.index + 1}"
  resource_group_name  = module.RG.resourcegroup_name.rg_name
  virtual_network_name = azurerm_virtual_network.github-action.name
  address_prefixes     = "${var.address_prefixes[count.index]}"
  count = 2

}

resource "azurerm_network_interface" "github-action" {
  location            = var.location
  resource_group_name = module.RG.resourcegroup_name.rg_name
  count = 2
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.github-action.id
    private_ip_address_allocation = "Dynamic"
  }
  
  tags = {
    Name = "github-action-nic ${count.index}"
    Env = "Dev"    
}

}
resource "azurerm_windows_virtual_machine" "github-action" {
  resource_group_name = module.RG.resourcegroup_name.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  count = 2
  network_interface_ids = [
    azurerm_network_interface.github-action[count.index]
  ]

  tags = {
    Name = "github-action ${count.index}"
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

module "SA" {
  source   = "./modules/StorageAccount"
  sname    = var.sname
  rgname   = var.rgname
  location = var.location
}
