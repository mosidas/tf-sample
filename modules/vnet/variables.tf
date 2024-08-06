variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
