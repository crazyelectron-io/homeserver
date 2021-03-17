
variable "resource_group_name" {
  description = "Azure resource group name"
}

variable "location" {
  description = "Location in which to deploy resources"
}

variable "rules_map" {
  type    = map(any)
  default = {}
}

variable "network_security_group_name" {
  description = "The name of the Network Security Group that we want to attach the rule to."
}

variable "apply_udp_block_rule" {
  description = "Applies the default udp block rule"
  default     = false
}
