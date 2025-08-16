variable "azure_subscription_id" {
  description = "The Azure Subscription ID where resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where resources will be created."
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group."
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "app_service_name" {
  description = "The name of the App Service."
  type        = string
}

variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "sql_database_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "sql_administrator_login_username" {
  description = "The administrator username for the SQL Server."
  type        = string
}

variable "sql_administrator_password" {
  description = "The administrator password for the SQL Server."
  type        = string
}

variable "firewall_rule_name" {
  description = "The name of the SQL Server firewall rule."
  type        = string
}

variable "repo_url" {
  description = "The URL of the Git repository to deploy to the App Service."
  type        = string
}
