module "resourcegroup" {
  source   = "../../modules/resourcegroup"
  name     = local.resource_group.name
  location = local.location.main
  tags     = local.tags
}

resource "random_id" "app" {
  byte_length = 8
}

module "webapp" {
  source                = "../../modules/webapp"
  app_service_plan_name = "asp-${local.app}-dev"
  app_insights_name     = "appi-${local.app}-dev-${random_id.app.id}"
  app_service_name      = "app-${local.app}-dev-${random_id.app.id}"
  os_type               = "Windows"
  sku_name              = "B1"
  dotnet_version        = "v8.0"
  location              = local.location.main
  resource_group_name   = module.resourcegroup.resource_group_name
  tags                  = local.tags
}

module "mssql_server" {
  source                        = "../../modules/mssql"
  sql_server_name               = "sql-${local.app}-dev"
  sql_database_name             = "sqldb-${local.app}-dev"
  database_version              = "12.0"
  sql_database_id               = var.sql_database_id
  sql_database_admin_password   = var.sql_database_admin_password
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
  location                      = local.location.main
  resource_group_name           = module.resourcegroup.resource_group_name
  tags                          = local.tags
}

module "mssql_extended_auditing_policy" {
  source = "../../modules/mssql_extended_auditing_policy"

  database_id                             = module.mssql_server.sql_database_id
  storage_endpoint                        = module.storage_account.primary_blob_endpoint
  storage_account_access_key              = module.storage_account.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
}

resource "random_integer" "storage" {
  min = 1000
  max = 9999
}

module "storage_account" {
  source                   = "../../modules/storage_account"
  storage_account_name     = "st${local.app}dev${random_integer.storage.result}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  location                 = local.location.main
  resource_group_name      = module.resourcegroup.resource_group_name
  tags                     = local.tags
}

module "storage_container" {
  source                 = "../../modules/storage_container"
  storage_account_name   = module.storage_account.storage_account_name
  storage_container_name = "container-${local.app}-dev"
  container_access_type  = "private"
}
