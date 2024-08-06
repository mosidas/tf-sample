locals {
  app = "myapp"

  tags = {
    app = local.app
    env = "dev"
  }

  location = {
    main = "japaneast"
    sub  = "japanwest"
  }

  resource_group = {
    name     = "rg-${local.app}-dev"
    location = local.location.main
  }
}

variable "sql_database_id" {}
variable "sql_database_admin_password" {
  type      = string
  sensitive = true
}
variable "vm_password" {
  type      = string
  sensitive = true
}
