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

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password " {
  type = string
  sensitive = true
}

variable "demoadfname" {
  description = "Data Factory Name"
  type = string
}

variable "tenant_id" {
  description = "tenant id"
  default = "b389dae6-fcaf-4bd7-9d45-7e96e87d725e"  
}

variable "object_id" {
  default = "3304432f-18fe-4a7a-a1e8-de0d71afad38"
  
}