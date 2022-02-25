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
  type        = string
}

variable "address_prefixes" {
  description = "Subnet Prefix"
  default        = ["10.0.2.0/24","10.0.1.0/.24"]
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true 
}