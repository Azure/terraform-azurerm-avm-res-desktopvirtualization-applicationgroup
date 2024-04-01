# We pick a random region from this list.
locals {
  azure_regions = [
    "centralindia",
    "uksouth",
    "ukwest",
    "japaneast",
    "australiaeast",
    "canadaeast",
    "canadacentral",
    "northeurope",
    "westeurope",
    "eastus",
    "eastus2",
    "westus",
    "westus2",
    "westus3",
    "northcentralus",
    "southcentralus",
    "westcentralus",
    "centralus",
  ]
}
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}

locals {
  existing_group = [for g in data.azuread_groups.existing : g if g.display_name == var.user_group_name]
}

locals {
  group_id = length(local.existing_group) > 0 ? local.existing_group[0].object_id : azuread_group.new[0].object_id
}

