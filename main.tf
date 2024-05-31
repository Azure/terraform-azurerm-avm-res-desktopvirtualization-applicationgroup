# Create Azure Virtual Desktop application group
resource "azurerm_virtual_desktop_application_group" "this" {
  host_pool_id                 = var.virtual_desktop_application_group_host_pool_id
  location                     = var.virtual_desktop_application_group_location
  name                         = var.virtual_desktop_application_group_name
  resource_group_name          = var.virtual_desktop_application_group_resource_group_name
  type                         = var.virtual_desktop_application_group_type
  default_desktop_display_name = var.virtual_desktop_application_group_default_desktop_display_name
  description                  = var.virtual_desktop_application_group_description
  friendly_name                = var.virtual_desktop_application_group_friendly_name
  tags                         = var.virtual_desktop_application_group_tags

  dynamic "timeouts" {
    for_each = var.virtual_desktop_application_group_timeouts == null ? [] : [var.virtual_desktop_application_group_timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_virtual_desktop_application_group.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_management_lock" "this" {
  count = (var.lock != null) ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.virtual_desktop_application_group_name}")
  scope      = azurerm_virtual_desktop_application_group.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

# Create Diagnostic Settings for AVD application group
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.virtual_desktop_application_group_name}"
  target_resource_id             = azurerm_virtual_desktop_application_group.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
}
