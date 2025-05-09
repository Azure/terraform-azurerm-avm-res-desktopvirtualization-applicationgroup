variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Azure account."
}

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
  default     = "vdhostpool"
  description = "The name of the AVD Host Pool to assign the application group to."
}

variable "virtual_desktop_application_group_default_desktop_display_name" {
  type        = string
  default     = null
  description = "(Optional) Option to set the display name for the default desktop application. Changing this forces a new resource to be created."
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
  default     = "VdappGroup"
  description = "(Required) The name of the Virtual Desktop Application Group. Changing the name forces a new resource to be created."
}

variable "virtual_desktop_application_group_type" {
  type        = string
  default     = "Desktop"
  description = "(Required) Type of Virtual Desktop Application Group. Valid options are `RemoteApp` or `Desktop` application groups. Changing this forces a new resource to be created."
}
