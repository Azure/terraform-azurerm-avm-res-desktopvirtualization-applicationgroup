terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
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
  source  = "Azure/avm-res-desktopvirtualization-hostpool/azurerm"
  version = "0.2.1"

  resource_group_name                           = azurerm_resource_group.this.name
  virtual_desktop_host_pool_load_balancer_type  = "BreadthFirst"
  virtual_desktop_host_pool_location            = azurerm_resource_group.this.location
  virtual_desktop_host_pool_name                = var.host_pool
  virtual_desktop_host_pool_resource_group_name = azurerm_resource_group.this.name
  virtual_desktop_host_pool_type                = "Pooled"
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }
}

/*
# Get an existing built-in role definition
data "azurerm_role_definition" "this" {
  name = "Desktop Virtualization User"
}
# This sample will create the group defined in the variable user_group_nam. It allows the code to deploy for an end to end to deployment however this is not a supported scenario and expects you to have the user group already synchcronized in Microsoft Entra ID per https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites?tabs=portal#users
# You should replace this with your own code to a data block to fetch the group in your own environment.
resource "azuread_group" "new" {
  display_name     = var.user_group_name
  security_enabled = true
}

# Assign the Azure AD group to the application group
resource "azurerm_role_assignment" "this" {
  principal_id                     = azuread_group.new.id
  scope                            = module.appgroup.resource.id
  role_definition_id               = data.azurerm_role_definition.this.id
  skip_service_principal_aad_check = false
}
*/

# This is the module desktop application group
module "appgroup" {
  source = "../../"

  virtual_desktop_application_group_host_pool_id                 = module.avm_res_desktopvirtualization_hostpool.resource.id
  virtual_desktop_application_group_location                     = azurerm_resource_group.this.location
  virtual_desktop_application_group_name                         = var.virtual_desktop_application_group_name
  virtual_desktop_application_group_resource_group_name          = azurerm_resource_group.this.name
  virtual_desktop_application_group_type                         = var.virtual_desktop_application_group_type
  enable_telemetry                                               = var.enable_telemetry
  virtual_desktop_application_group_default_desktop_display_name = var.virtual_desktop_application_group_default_desktop_display_name
  virtual_desktop_application_group_description                  = var.virtual_desktop_application_group_description
  virtual_desktop_application_group_friendly_name                = var.virtual_desktop_application_group_friendly_name
}

# Sample applications
# Virtual desktop application name must be 1 - 260 characters long, contain only letters, numbers and hyphens.
resource "azurerm_virtual_desktop_application" "edge" {
  application_group_id         = module.appgroup.resource.id
  command_line_argument_policy = "DoNotAllow"
  name                         = "MicrosoftEdge"
  path                         = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  command_line_arguments       = "--incognito"
  description                  = "Microsoft Edge"
  friendly_name                = "Microsoft Edge"
  icon_index                   = 0
  icon_path                    = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  show_in_portal               = false
}

resource "azurerm_virtual_desktop_application" "wordpad" {
  application_group_id         = module.appgroup.resource.id
  command_line_argument_policy = "DoNotAllow"
  name                         = "WordPad"
  path                         = "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe"
  description                  = "WordPad application"
  friendly_name                = "WordPad"
  icon_index                   = 0
  icon_path                    = "C:\\Program Files\\Windows NT\\Accessories\\wordpad.exe"
}
