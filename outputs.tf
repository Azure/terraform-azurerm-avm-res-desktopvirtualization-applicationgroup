output "azurerm_virtual_desktop_application_group" {
  description = "Name of the Azure Virtual Desktop DAG"
  value       = azurerm_virtual_desktop_application_group.dag.name
}

output "azurerm_virtual_desktop_application_group_id" {
  description = "ID of the Azure Virtual Desktop DAG"
  value       = azurerm_virtual_desktop_application_group.dag.id
}
