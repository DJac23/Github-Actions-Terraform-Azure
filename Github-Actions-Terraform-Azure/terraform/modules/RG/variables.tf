variable "rgname" {
  type = string
}
variable "location" {
  type = string
}
variable "sname" {
  type = string
}
variable "instance_tags" {
  type = map (string)
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password " {
  type = string
  sensitive = true
}
