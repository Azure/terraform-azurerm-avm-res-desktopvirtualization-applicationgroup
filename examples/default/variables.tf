variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "dag" {
  type        = string
  description = "The name of the AVD Application Group."
  default     = "appgroup-1"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.dag))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "dagtype" {
  type        = string
  default     = "Desktop"
  description = "The type of the AVD Application Group. Valid values are 'Desktop' and 'RemoteApp'."
}

variable "host_pool_id" {
  type        = string
  default = "/subscriptions/b0aeeba8-4430-4cf1-acbc-6e24cadf86c9/resourceGroups/rg-avd-avd1-dev-use-service-objects/providers/Microsoft.DesktopVirtualization/hostpools/fbde3f95-6492-41bd-8952-7723bc788f8c"
  description = "The ID of the AVD Host Pool to assign the application group to."

}

variable "user_group_name" {
  type        = string
  default     = "avdusersgrp"
  description = "Microsoft Entra ID User Group for AVD users"
}
