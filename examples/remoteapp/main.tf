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
  min = 0
  max = length(local.azure_regions) - 1
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = local.azure_regions[random_integer.region_index.result]
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

# This is the module desktop application group
module "appgroup" {
  source              = "../../"
  enable_telemetry    = var.enable_telemetry
  type                = var.type
  name                = var.name
  description         = var.description
  hostpool            = var.host_pool
  user_group_name     = var.user_group_name
  resource_group_name = var.resource_group_name
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }
}

# Sample applications
# Virtual desktop application name must be 1 - 260 characters long, contain only letters, numbers and hyphens.
resource "azurerm_virtual_desktop_application" "edge" {
  name                         = "MicrosoftEdge"
  application_group_id         = module.appgroup.azurerm_virtual_desktop_application_group_id
  friendly_name                = "Microsoft Edge"
  description                  = "Microsoft Edge"
  path                         = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  command_line_argument_policy = "DoNotAllow"
  command_line_arguments       = "--incognito"
  show_in_portal               = false
  icon_path                    = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  icon_index                   = 0
}

resource "azurerm_virtual_desktop_application" "wordpad" {
  name                         = "WordPad"
  application_group_id         = module.appgroup.azurerm_virtual_desktop_application_group_id
  friendly_name                = "WordPad"
  description                  = "WordPad application"
  path                         = "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe"
  command_line_argument_policy = "DoNotAllow" // Allow, DoNotAllow, Require
  icon_path                    = "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe"
  icon_index                   = 0
}
