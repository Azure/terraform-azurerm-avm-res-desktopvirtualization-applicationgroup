variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "host_pool" {
  type        = string
  default     = "avdhostpool"
  description = "The name of the AVD Host Pool to assign the application group to."
}

variable "user_group_name" {
  type        = string
  default     = "avdusersgrp"
  description = "Microsoft Entra ID User Group for AVD users"
}

variable "virtual_desktop_application_group_default_desktop_display_name" {
  type        = string
  default     = null
  description = "(Optional) Option to set the display name for the default sessionDesktop desktop when `type` is set to `Desktop`."
}

variable "virtual_desktop_application_group_description" {
  type        = string
  default     = "AVD Desktop Application Group"
  description = "(Optional) Option to set a description for the Virtual Desktop Application Group."
}

variable "virtual_desktop_application_group_friendly_name" {
  type        = string
  default     = null
  description = "(Optional) Option to set a friendly name for the Virtual Desktop Application Group."
}

variable "virtual_desktop_application_group_name" {
  type        = string
  default     = "vdappgroup"
  description = "(Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created."

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.virtual_desktop_application_group_name))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "virtual_desktop_application_group_type" {
  type        = string
  default     = "RemoteApp"
  description = "(Required) Type of Virtual Desktop Application Group. Valid options are `RemoteApp` or `Desktop` application groups. Changing this forces a new resource to be created."
}
