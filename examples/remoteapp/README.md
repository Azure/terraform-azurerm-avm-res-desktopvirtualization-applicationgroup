<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
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
  dagtype             = var.dagtype
  dag                 = var.dag
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_virtual_desktop_application.edge](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) (resource)
- [azurerm_virtual_desktop_application.wordpad](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_dag"></a> [dag](#input\_dag)

Description: The name of the AVD Application Group.

Type: `string`

Default: `"appgroup-1"`

### <a name="input_dagtype"></a> [dagtype](#input\_dagtype)

Description: The type of the AVD Application Group. Valid values are 'Desktop' and 'RemoteApp'.

Type: `string`

Default: `"RemoteApp"`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_host_pool"></a> [host\_pool](#input\_host\_pool)

Description: The name of the AVD Host Pool to assign the application group to.

Type: `string`

Default: `"avdhostpool"`

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure location where the AVD hostpool resources is deployed.

Type: `string`

Default: `"eastus"`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the AVD Host Pool is deployed.

Type: `string`

Default: `"rg-avm-test"`

### <a name="input_user_group_name"></a> [user\_group\_name](#input\_user\_group\_name)

Description: Microsoft Entra ID User Group for AVD users

Type: `string`

Default: `"avdusersgrp"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_appgroup"></a> [appgroup](#module\_appgroup)

Source: ../../

Version:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: 0.3.0

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->