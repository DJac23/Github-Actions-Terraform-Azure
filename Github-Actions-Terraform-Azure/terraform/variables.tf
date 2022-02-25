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
variable "subnet_name" {
  description = "Azure Subnet Name"
  type        = list 
}

variable "address_prefixes" {
  description = "Subnet Prefix"
  default        = list
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true 
}