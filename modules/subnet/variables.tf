variable "resource_group_name" {
  description = "The name of the resource group we want to use"
  default     = ""
  type        = string
}

variable "location" {
  description = "The location/region where we are creating the resource"
  default     = ""
  type        = string
}

variable "tags" {
  description = "The tags to assign to the VNET resource we are creating"
  type        = map(any)
  default     = {}
}

# Everything below is for the module

variable "vnet_name" {
  description = "Name of the vnet to create the subnets in"
  default     = ""
  type        = string
}

variable "subnets" {
  type        = list
  description = "The address prefix to use for the subnet"
  default     = []
}

variable "add_endpoint" {
  description = "Should we be adding an endpoint to the subnet?"
  default     = false
  type        = bool
}