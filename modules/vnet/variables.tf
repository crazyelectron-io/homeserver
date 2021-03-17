variable "resource_group_name" {
  description = "The name of the resource group we want to create the VNET in"
  default     = ""
  type        = string
}

variable "location" {
  description = "The location/region where we are creating the VNET resource"
  default     = ""
  type        = string
}

variable "tags" {
  description = "The tags to associate to the VNET resource we are creating"
  type        = map
  default     = {}
}

# Everything below is for the module

variable "vnet_name" {
  description = "Name of the vnet to create"
  default     = ""
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = ""
}
