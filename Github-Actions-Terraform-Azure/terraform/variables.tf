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

variable "instance_tags" {
  type = object ({
    Name = String
    Env = String
  }) 
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