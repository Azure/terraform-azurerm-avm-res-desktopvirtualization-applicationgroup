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

# Get an existing built-in role definition
data "azurerm_role_definition" "this" {
  name = "Desktop Virtualization User"
}

# Get an existing Azure AD group that will be assigned to the application group
data "azuread_groups" "existing" {
  display_names    = [var.user_group_name]
  security_enabled = true
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
