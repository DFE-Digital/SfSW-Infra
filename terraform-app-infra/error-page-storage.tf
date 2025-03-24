resource "azurerm_storage_account" "error_page_sa" {
  name                             = "sa${var.project_name}${var.instance}"
  resource_group_name              = azurerm_resource_group.webapp_rg.name
  location                         = azurerm_resource_group.webapp_rg.location
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  min_tls_version                  = "TLS1_2"
  account_kind                     = "StorageV2"
  public_network_access_enabled    = false
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  https_traffic_only_enabled       = true

  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
    restore_policy {
      days = 29
    }
    versioning_enabled            = true
    change_feed_enabled           = true
    change_feed_retention_in_days = 30
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "error_page_container" {
  name                  = "error-pages-${var.instance}"
  storage_account_id    = azurerm_storage_account.error_page_sa.id
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "error_page_storage_policy" {
  storage_account_id = azurerm_storage_account.error_page_sa.id
  rule {
    name    = "error-page-versioning-${var.instance}"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      version {
        delete_after_days_since_creation = 30
      }
    }
  }
}
