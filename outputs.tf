output "resource" {
  description = "This output is the full output for the resource to allow flexibility to reference all possible values for the resource. Example usage: module.<modulename>.resource.id"
  value       = azurerm_virtual_desktop_application_group.this
}

output "resource_id" {
  value       = azurerm_virtual_desktop_application_group.this.id
  description = "The ID of the Azure Virtual Desktop application group"
}
