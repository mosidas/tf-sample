module "rg" {
  source   = "../../modules/resource-group"
  name     = local.resource_group.name
  location = local.location.main
  tags     = local.tags
}

module "webapp" {
  source                = "../../modules/webapp"
  app_service_plan_name = "appservice-${local.app}-dev"
  app_insights_name     = "appinsights-${local.app}-dev"
  app_service_name      = "webapp-${local.app}-dev"
  location              = local.location.main
  resource_group_name   = local.resource_group.name
  tags                  = local.tags
}

module "sqldb" {
  source                      = "../../modules/mssql"
  sql_server_name             = "sql-${local.app}-dev"
  sql_database_name           = "sqldb-${local.app}-dev"
  database_version            = "12.0"
  sql_database_id             = var.sql_database_id
  sql_database_admin_password = var.sql_database_admin_password
  location                    = local.location.main
  resource_group_name         = local.resource_group.name
  tags                        = local.tags
}

module "storage" {
  source                   = "../../modules/storage"
  storage_account_name     = "storage${local.app}dev"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  location                 = local.location.main
  resource_group_name      = local.resource_group.name
  tags                     = local.tags
}
