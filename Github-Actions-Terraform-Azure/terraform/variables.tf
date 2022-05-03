variable "rgname" {
  description = "Resource Group Name"
  type        = string
}
variable "location" {
  description = "Azure location"
  type        = string
}

variable "sname" {
  description = "Azure Storage Account"
  type        = string
}

variable "config_name" {
  type = string  
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true
}

# variable "demoadfname" {
#   description = "Data Factory Name"
#   type = string
# }

# variable "tenant_id" {
#   description = "tenant id"
#   default = "b389dae6-fcaf-4bd7-9d45-7e96e87d725e"  
# }

# variable "object_id" {
#   default = "3304432f-18fe-4a7a-a1e8-de0d71afad38"  
# }

variable "Sub_ID" {
    type = list
    default = ["e812877a-b4ba-4591-88b7-93406abf1c21"]
  
}

# variable "managed_virtual_network_enabled" {
#   type = bool
#   default = true
# }

# variable "virtual_network_enabled" {
#   type = bool
#   default = true
# }

# variable "data_exfiltration_protection_enabled" {
#   type = bool
#   default = true
# }

# variable "aad_admin_login" {
#   type = string
#   default = "AzureAD Admin"
  
# }

# variable "tags" { 
#   type = list(string)
#   default = ["dev","test","prod"]
# }

# variable "managedIRname" {
#   type = string 
#   default = "managedIR"  
# }

# variable "dev-dlake-filesys-name" {
#   default = "dev-dlake-filesys"  
# }

# variable "azurerm_synapse_workspace_name" {
#     default = "dev-synwks-001"  
# }

# variable "SQLDBName" {
#   default = "SQLDB"
# }

# variable "syndatalake-blob-name" {
#   default = "syndatalake_blob"  
# }

# variable "syndatalake-table-name" {
#   default = "syndatalake_table"  
# }

variable "environment" {
  description =  "Name of environment"
  default =  "dev"
}

variable "pls_name" {
    default = "pls"  
}

variable "linuxVm_Name" {
    default = {
      "0" = "linux_vm"
      "1" = "linux_vm"
    }
}