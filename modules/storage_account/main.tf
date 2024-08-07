resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = var.min_tls_version

  # subnet_idsが空でない場合は、network_rulesの値を設定する
  dynamic "network_rules" {
    for_each = length(var.subnet_ids) > 0 ? [1] : []
    content {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      virtual_network_subnet_ids = var.subnet_ids
    }
  }
  tags = var.tags
}

