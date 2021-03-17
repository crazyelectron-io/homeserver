variable "name_prefix" {
  description = "The name prefix to use for resources being deployed"
  default     = "home"
  type        = string
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "The location/region where we are deploying the resources"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID where we are deploying the resources"
}

variable "default_tags" {
  description = "The default tags applied to every resource we are creating"
  default     = {}
  type        = map(any)
}

variable "address_space" {
  description = "The address space to allocate for the VNET resource we are creating"
  default     = ""
  type        = string
}

variable "network_octets" {
  type        = string
  default     = ""
  description = "First two octects of the subnet e.g. the X.Y in X.Y.0.0"
}

variable "subnets" {
  type = map(any)
  default = {
    "app" = { subnet_octet = "0" }
  }
  description = "The address prefix to use for the subnets in the VNET"
}

variable "subnet" {
  description = ""
  default     = ""
}

variable "default_ip_whitelist" {
  type        = list(string)
  default     = ["86.94.64.6"]
  description = "Remote access default IP whitelist"
}

variable "add_endpoints" {
  description = "Indicates if we have to add endpoints to the subnet created"
  type        = bool
  default     = false
}

variable "vm_size" {
  description = "Size of the VM to deploy"
  type        = string
  default     = ""
}