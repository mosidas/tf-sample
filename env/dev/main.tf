module "resourcegroup" {
  source   = "../../modules/resourcegroup"
  name     = local.resource_group.name
  location = local.location.main
  tags     = local.tags
}

resource "random_id" "app" {
  byte_length = 8
}

module "app_insights" {
  source              = "../../modules/application_insight"
  app_insights_name   = "appi-${local.app}-dev-${random_id.app.id}"
  location            = local.location.main
  resource_group_name = module.resourcegroup.resource_group_name
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
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = module.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = module.app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
  connection_string_name  = "SQLAZURECONNSTR"
  connection_string_type  = "SQLAzure"
  connection_string_value = module.mssql_server.sql_connection_string
  tags                    = local.tags
}

module "webapp_slot" {
  source         = "../../modules/webapp_slot"
  slot_name      = "stg"
  app_service_id = module.webapp.app_service_id
  dotnet_version = "v8.0"
  location       = local.location.main
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = module.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = module.app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
  connection_string_name  = "SQLAZURECONNSTR"
  connection_string_type  = "SQLAzure"
  connection_string_value = module.mssql_server.sql_connection_string
  tags                    = local.tags
}

resource "random_id" "front_door" {
  byte_length = 8
}

module "front_door" {
  source                       = "../../modules/front_door"
  location                     = local.location.main
  resource_group_name          = module.resourcegroup.resource_group_name
  profile_name                 = "fd-${local.app}-dev-001"
  front_door_sku_name          = "Standard_AzureFrontDoor"
  endpoint_name                = "ep-${local.app}-dev.${lower(random_id.front_door.hex)}"
  front_door_origin_group_name = "fd-og-${local.app}-dev"
  front_door_origin_name       = "fd-origin-${local.app}-dev"
  webapp_default_hostname      = module.webapp.default_hostname
  front_door_route_name        = "fd-route-${local.app}-dev"
  tags                         = local.tags
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

module "vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-${local.app}-dev"
  location            = local.location.main
  resource_group_name = module.resourcegroup.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  source = "../../modules/subnet"

  for_each = {
    subnet1 = { name = "subnet-${local.app}-dev-001", address_prefixes = ["10.0.1.0/24"], delegation_name = "", service_delegation_name = "", service_delegation_actions = [] }
    subnet2 = { name = "subnet-${local.app}-dev-002", address_prefixes = ["10.0.2.0/24"], delegation_name = "", service_delegation_name = "", service_delegation_actions = [] }
    subnet3 = { name = "subnet-${local.app}-dev-003", address_prefixes = ["10.0.3.0/24"], delegation_name = "delegation-${local.app}-dev", service_delegation_name = "Microsoft.Web/serverFarms", service_delegation_actions = ["Microsoft.Web/serverFarms"] }
  }

  name                       = each.value.name
  vnet_name                  = module.vnet.name
  location                   = local.location.main
  resource_group_name        = module.resourcegroup.resource_group_name
  address_prefixes           = each.value.address_prefixes
  delegation_name            = each.value.delegation_name
  service_delegation_name    = each.value.service_delegation_name
  service_delegation_actions = each.value.service_delegation_actions
}

module "vnet_integration" {
  source         = "../../modules/vnet_integration"
  app_service_id = module.webapp.app_service_id
  subnet_id      = module.subnet.subnet3.id
}

module "vm" {
  source                = "../../modules/vm_windows11"
  name                  = "vm-${local.app}-dev"
  user_name             = "${local.app}admin"
  password              = var.vm_password
  location              = local.location.main
  resource_group_name   = module.resourcegroup.resource_group_name
  nic_name              = "nic-${local.app}-dev"
  nsg_name              = "nsg-${local.app}-dev"
  ip_configuration_name = "ipconfig-${local.app}-dev"
  subnet_id             = module.subnet.subnet1.id
  vm_size               = "Standard_B1s"
  storage_account_type  = "Standard_LRS"
  primary_blob_endpoint = module.storage_account.primary_blob_endpoint
  tags                  = local.tags
}

module "bastion" {
  source               = "../../modules/bastion"
  name                 = "bastion-${local.app}-dev"
  resource_group_name  = module.resourcegroup.resource_group_name
  location             = local.location.main
  virtual_network_name = module.vnet.name
  pip_name             = "pip-${local.app}-dev"
  bastion_sku          = "Standard"
}
