<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-desktopvirtualization-applicationgroup

Terraform Azure Verified Module for Azure Virtual Desktop application groups

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.6.6, < 2.0.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>= 2.44.1, < 3.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.11.1, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.1, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>= 2.44.1, < 3.0.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.11.1, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.1, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [azurerm_role_assignment.role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_virtual_desktop_application_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azuread_group.user_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azurerm_role_definition.role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_user_group_name"></a> [user\_group\_name](#input\_user\_group\_name)

Description: Microsoft Entra ID User Group for AVD users

Type: `string`

### <a name="input_virtual_desktop_application_group_host_pool_id"></a> [virtual\_desktop\_application\_group\_host\_pool\_id](#input\_virtual\_desktop\_application\_group\_host\_pool\_id)

Description: (Required) Resource ID for a Virtual Desktop Host Pool to associate with the Virtual Desktop Application Group. Changing the name forces a new resource to be created.

Type: `string`

### <a name="input_virtual_desktop_application_group_location"></a> [virtual\_desktop\_application\_group\_location](#input\_virtual\_desktop\_application\_group\_location)

Description: (Required) The location/region where the Virtual Desktop Application Group is located. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_virtual_desktop_application_group_name"></a> [virtual\_desktop\_application\_group\_name](#input\_virtual\_desktop\_application\_group\_name)

Description: (Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created.

Type: `string`

### <a name="input_virtual_desktop_application_group_resource_group_name"></a> [virtual\_desktop\_application\_group\_resource\_group\_name](#input\_virtual\_desktop\_application\_group\_resource\_group\_name)

Description: (Required) The name of the resource group in which to create the Virtual Desktop Application Group. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_virtual_desktop_application_group_type"></a> [virtual\_desktop\_application\_group\_type](#input\_virtual\_desktop\_application\_group\_type)

Description: (Required) Type of Virtual Desktop Application Group. Valid options are `RemoteApp` or `Desktop` application groups. Changing this forces a new resource to be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: The lock level to apply to the AVD Host Pool. Default is `ReadOnly`. Possible values are`Delete`, and `ReadOnly`.

Type:

```hcl
object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
```

Default: `{}`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on the AVD Host Pool. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    condition                              = string
    condition_version                      = string
    skip_service_principal_aad_check       = bool
    delegated_managed_identity_resource_id = string
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Map of tags to assign to the Key Vault resource.

Type: `map(any)`

Default: `null`

### <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled)

Description: Whether enable tracing tags that generated by BridgeCrew Yor.

Type: `bool`

Default: `false`

### <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix)

Description: Default prefix for generated tracing tags

Type: `string`

Default: `"avm_"`

### <a name="input_virtual_desktop_application_group_default_desktop_display_name"></a> [virtual\_desktop\_application\_group\_default\_desktop\_display\_name](#input\_virtual\_desktop\_application\_group\_default\_desktop\_display\_name)

Description: (Optional) Option to set the display name for the default sessionDesktop desktop when `type` is set to `Desktop`.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_application_group_description"></a> [virtual\_desktop\_application\_group\_description](#input\_virtual\_desktop\_application\_group\_description)

Description: (Optional) Option to set a description for the Virtual Desktop Application Group.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_application_group_friendly_name"></a> [virtual\_desktop\_application\_group\_friendly\_name](#input\_virtual\_desktop\_application\_group\_friendly\_name)

Description: (Optional) Option to set a friendly name for the Virtual Desktop Application Group.

Type: `string`

Default: `null`

### <a name="input_virtual_desktop_application_group_tags"></a> [virtual\_desktop\_application\_group\_tags](#input\_virtual\_desktop\_application\_group\_tags)

Description: (Optional) A mapping of tags to assign to the resource.

Type: `map(string)`

Default: `null`

### <a name="input_virtual_desktop_application_group_timeouts"></a> [virtual\_desktop\_application\_group\_timeouts](#input\_virtual\_desktop\_application\_group\_timeouts)

Description: - `create` - (Defaults to 60 minutes) Used when creating the Virtual Desktop Application Group.
- `delete` - (Defaults to 60 minutes) Used when deleting the Virtual Desktop Application Group.
- `read` - (Defaults to 5 minutes) Used when retrieving the Virtual Desktop Application Group.
- `update` - (Defaults to 60 minutes) Used when updating the Virtual Desktop Application Group.

Type:

```hcl
object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_azurerm_virtual_desktop_application_group"></a> [azurerm\_virtual\_desktop\_application\_group](#output\_azurerm\_virtual\_desktop\_application\_group)

Description: Name of the Azure Virtual Desktop DAG

### <a name="output_azurerm_virtual_desktop_application_group_id"></a> [azurerm\_virtual\_desktop\_application\_group\_id](#output\_azurerm\_virtual\_desktop\_application\_group\_id)

Description: ID of the Azure Virtual Desktop DAG

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->