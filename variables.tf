/************************************************/
/************ VARIABLES ********************/
/************************************************/
variable "subscription_id" {
  description = "Azure subscription ID"
}

variable "client_id" {
  description = "Azure Application ID"
}

variable "client_secret" {
  description = "Azure Client Secret"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "resource_group" {
  description = "The name of the resource group in which to create the resources."
}

variable "location" {
  description = "The location/region where the resources is created"
}

variable "project_name" {
  description = "The shortened abbreviation to represent your project name."
  default     = "ESGI-TERRAFORMV1"
}

variable "env_name" {
  description = "Environnment Name"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "admin_password" {
  description = "vmpassword"
  default     = "vmadmin123*"
}