variable "resource_group_name" {
  description = "Resource group name for deployment of the Azure remote state container"
  type        = string
  default     = "TerraformStateRG"
}

variable "location" {
  description = "The region where the resources are deployed"
  type        = string
  default     = "westeurope"
}

variable "name_prefix" {
  description = "The naming prefixed used for all resources"
  type        = string
  default     = "home"
}