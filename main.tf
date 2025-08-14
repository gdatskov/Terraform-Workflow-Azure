terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "taskboardstorage"
    container_name       = "taskboardcontainer"
    key                  = "terraform.tfstate"
  }
}



provider "azurerm" {
  features {}
  subscription_id = "a95dae05-dd40-452e-bd12-c143df37b546"
}

provider "random" {

}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "azure-rg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location

}

resource "azurerm_service_plan" "azure-sp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.azure-rg.name
  location            = azurerm_resource_group.azure-rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_mssql_server" "azure-db-server" {
  name                         = "${var.sql_server_name}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.azure-rg.name
  location                     = azurerm_resource_group.azure-rg.location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login_username
  administrator_login_password = var.sql_administrator_password

}

resource "azurerm_mssql_database" "azure-db" {
  name         = "${var.sql_database_name}-${random_integer.ri.result}"
  server_id    = azurerm_mssql_server.azure-db-server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"

  storage_account_type = "Local"
  zone_redundant       = false
  geo_backup_enabled   = false
}

resource "azurerm_mssql_firewall_rule" "azure-db-fw-rule" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.azure-db-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_linux_web_app" "azure-app" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.azure-rg.name
  location            = azurerm_resource_group.azure-rg.location
  service_plan_id     = azurerm_service_plan.azure-sp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.azure-db-server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.azure-db.name};User ID=${azurerm_mssql_server.azure-db-server.administrator_login};Password=${azurerm_mssql_server.azure-db-server.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

# Deploy code from public GitHub repository
resource "azurerm_app_service_source_control" "azure-app-source" {
  app_id                 = azurerm_linux_web_app.azure-app.id
  branch                 = "main"
  repo_url               = var.repo_url
  use_manual_integration = true
}