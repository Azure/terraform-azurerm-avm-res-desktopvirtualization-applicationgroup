terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This picks a random region from the list of regions.
resource "random_integer" "region_index" {
  max = length(local.azure_regions) - 1
  min = 0
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.azure_regions[random_integer.region_index.result]
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_log_analytics_workspace" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
}

module "avm_res_desktopvirtualization_hostpool" {
  source                                        = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
  version                                       = "0.1.4"
  virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_host_pool_name                = var.host_pool
  virtual_desktop_host_pool_location            = azurerm_resource_group.this.location
  virtual_desktop_host_pool_load_balancer_type  = "BreadthFirst"
  virtual_desktop_host_pool_type                = "Pooled"
  resource_group_name                           = azurerm_resource_group.this.name
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }
}

# This is the module desktop application group
module "appgroup" {
  source                                                         = "../../"
  enable_telemetry                                               = var.enable_telemetry
  virtual_desktop_application_group_default_desktop_display_name = var.virtual_desktop_application_group_default_desktop_display_name
  virtual_desktop_application_group_description                  = var.virtual_desktop_application_group_description
  virtual_desktop_application_group_friendly_name                = var.virtual_desktop_application_group_friendly_name
  virtual_desktop_application_group_host_pool_id                 = module.avm_res_desktopvirtualization_hostpool.resource.id
  virtual_desktop_application_group_location                     = azurerm_resource_group.this.location
  virtual_desktop_application_group_resource_group_name          = azurerm_resource_group.this.name
  virtual_desktop_application_group_name                         = var.virtual_desktop_application_group_name
  virtual_desktop_application_group_type                         = var.virtual_desktop_application_group_type
  user_group_name                                                = var.user_group_name
}
