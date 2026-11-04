# terraform-azurerm-avm-res-desktopvirtualization-applicationgroup

[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/Azure/terraform-azurerm-avm-res-desktopvirtualization-applicationgroup.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-avm-res-desktopvirtualization-applicationgroup "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/Azure/terraform-azurerm-avm-res-desktopvirtualization-applicationgroup.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-avm-res-desktopvirtualization-applicationgroup "Percentage of issues still open")

Terraform Azure Verified Module to deploy Azure Virtual Desktop Application Group and associated resources.

## Upgrading from 0.3.0

When telemetry is enabled, the module creates an empty subscription-scoped Azure deployment. The deployment identity needs `Microsoft.Resources/deployments/read`, `Microsoft.Resources/deployments/write`, and `Microsoft.Resources/deployments/delete` permissions at subscription scope. Set `enable_telemetry = false` to opt out. The deployment is updated on normal applies, including otherwise unchanged applies.

The old telemetry objects are forgotten without being destroyed. Existing state may require the previous ModTM and random providers for one final initialization; review the upgrade plan.
