# Define the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Define locals to compute names based on prefix
locals {
  resource_group_name    = "${var.prefix}rgrichdizz"
  app_service_name       = "${var.prefix}asrichdizz"
  app_service_plan_name  = "${var.prefix}asprichdizz"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = local.resource_group_name
  location = var.location
} 

# Create an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Windows"
  sku {
    tier = "Basic"
    size = "B1" # Choose based on your needs (B1 is low-cost)
  }
} 

# Create an App Service (Web App)
resource "azurerm_app_service" "example" {
  name                = local.app_service_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  # Define app settings (environment variables)
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1" # Optional: Use if deploying from a package (like a ZIP file)
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "WEBSITE_STACK"                = "node"
  }
}

# Output the App Service URL
output "app_service_url" {
  value = azurerm_app_service.example.default_site_hostname
}
