<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form for Desktop Application Group with the Desktop type

This sample will not fetch the group and assigned the group however the code is included and commented out to give a you a sample.
It expects you to have the user group already synchcronized in Microsoft Entra ID per https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites?tabs=portal#users

Change default values in the variables.tf file for your environment.

```hcl
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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
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
  version = ">= 0.3.0"

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

data "azuread_group" "existing" {
  display_name     = var.user_group_name
  security_enabled = true
}


# Assign the Azure AD group to the application group
resource "azurerm_role_assignment" "this" {
  principal_id                     = data.azuread_group.existing.id
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71, < 5.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: The subscription ID for the Azure account.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_host_pool"></a> [host\_pool](#input\_host\_pool)

Description: The name of the AVD Host Pool to assign the application group to.

Type: `string`

Default: `"vdhostpool"`

### <a name="input_virtual_desktop_application_group_default_desktop_display_name"></a> [virtual\_desktop\_application\_group\_default\_desktop\_display\_name](#input\_virtual\_desktop\_application\_group\_default\_desktop\_display\_name)

Description: (Optional) Option to set the display name for the default desktop application. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_application_group_description"></a> [virtual\_desktop\_application\_group\_description](#input\_virtual\_desktop\_application\_group\_description)

Description: (Optional) Option to set a description for the Virtual Desktop Application Group.

Type: `string`

Default: `"AVD Desktop Application Group"`

### <a name="input_virtual_desktop_application_group_friendly_name"></a> [virtual\_desktop\_application\_group\_friendly\_name](#input\_virtual\_desktop\_application\_group\_friendly\_name)

Description: (Optional) Option to set a friendly name for the Virtual Desktop Application Group.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_application_group_name"></a> [virtual\_desktop\_application\_group\_name](#input\_virtual\_desktop\_application\_group\_name)

Description: (Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created.

Type: `string`

Default: `"VdappGroup"`

### <a name="input_virtual_desktop_application_group_type"></a> [virtual\_desktop\_application\_group\_type](#input\_virtual\_desktop\_application\_group\_type)

Description: (Required) Type of Virtual Desktop Application Group. Valid options are `RemoteApp` or `Desktop` application groups. Changing this forces a new resource to be created.

Type: `string`

Default: `"Desktop"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_appgroup"></a> [appgroup](#module\_appgroup)

Source: ../../

Version:

### <a name="module_avm_res_desktopvirtualization_hostpool"></a> [avm\_res\_desktopvirtualization\_hostpool](#module\_avm\_res\_desktopvirtualization\_hostpool)

Source: Azure/avm-res-desktopvirtualization-hostpool/azurerm

Version: >= 0.3.0

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: 0.3.0

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->