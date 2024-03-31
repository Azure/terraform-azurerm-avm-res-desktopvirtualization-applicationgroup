locals {
  resource_group_location            = try(data.azurerm_resource_group.parent[0].location, null)
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}

locals {
  existing_group = [for g in data.azuread_groups.existing : g if g.display_name == var.user_group_name]
}

locals {
  group_id = length(local.existing_group) > 0 ? local.existing_group[0].object_id : azuread_group.new[0].object_id
}
