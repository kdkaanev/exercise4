variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}
variable "resource_group_location" {
  type        = string
  description = "The location of the resource group"
}
variable "app_service_plan_name" {
  type        = string
  description = "The name of the service plan"

}

variable "web_app_name" {
  type        = string
  description = "Web App name"
}

variable "resource_source_control" {
  type        = string
  description = "The name of the source control"
}
variable "resource_mysql_server" {
  type        = string
  description = "The name of the mysqlserver"
}
variable "resource_group_mysql_database" {
  type        = string
  description = "The name of the resource group"
}
variable "resource_firewall_rule" {
  type        = string
  description = "The name of the firewall rule"
}
variable "sql_admin_login" {
  type        = string
  description = "sql admin"
}
variable "sql_admin_pass" {
  type        = string
  description = "Sql admin pass"
}
variable "git_hub_url" {
  type        = string
  description = "Git hub web adress"
}
