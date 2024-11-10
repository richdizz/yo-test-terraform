# Define the Azure provider
provider "azurerm" {
  features {}
  prefix = var.prefix
  subscription_id = var.subscription_id
}

# Define variables for resource group and location
variable "prefix" {}
variable "subscription_id" {}
variable "resource_group_name" {
  default = "richdizz_yotest"
}

variable "location" {
  default = "eastus"
}

variable "app_service_name" {
  default = var.prefix + "_as_richdizz"
}

variable "app_service_plan_name" {
  default = var.prefix + "_asp_richdizz"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Basic"
    size = "B1" # Choose based on your needs (B1 is low-cost)
  }
}

# Create an App Service (Web App)
resource "azurerm_app_service" "example" {
  name                = var.app_service_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  # Define app settings (environment variables)
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1" # Optional: Use if deploying from a package (like a ZIP file)
  }
}

# Output the App Service URL
output "app_service_url" {
  value = azurerm_app_service.example.default_site_hostname
}
