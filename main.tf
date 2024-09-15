terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}



# Configure the Microsoft Azure Provider

resource "azurerm_resource_group" "arg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwa" {
  name                = "${var.web_app_name}-${random_integer.ri.result}"
  resource_group_name =  "${var.resource_group_name}-${random_integer.ri.result}"
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserverkk.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.nameDB.name};User ID=${azurerm_mssql_server.sqlserverkk.administrator_login};Password=${azurerm_mssql_server.sqlserverkk.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }

}
resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.alwa.id
  repo_url               = "https://github.com/kdkaanev/taskboard"
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "sqlserverkk" {
  name                         = "${var.resource_mysql_server}-${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_pass
  minimum_tls_version          = "1.2"

}
resource "azurerm_mssql_database" "nameDB" {
  name           = var.resource_group_mysql_database
  server_id      = azurerm_mssql_server.sqlserverkk.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false



}


resource "azurerm_mssql_firewall_rule" "firewall" {
  name             = var.resource_firewall_rule
  server_id        = azurerm_mssql_server.sqlserverkk.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}