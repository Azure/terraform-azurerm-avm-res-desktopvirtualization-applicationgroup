# Remoteapp example

This deploys the module for Desktop Application Group with the remoteapp type with 2 sample applications.

This sample will not fetch the group and assigned the group however the code is included and commented out to give a you a sample.
It expects you to have the user group already synchcronized in Microsoft Entra ID per https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites?tabs=portal#users

Change default values in the variables.tf file for your environment.

Host Pool 0.6.0 configures RDP redirection defaults for drives, devices, USB, clipboard, printers, COM ports, and smartcards, and manages `custom_rdp_properties` on updates. The previous 0.2.1 dependency left the value unset and ignored changes. It also passed the default VM template as the JSON string `null`; 0.6.0 leaves the template unset. Review the plan before upgrading an existing example deployment.
