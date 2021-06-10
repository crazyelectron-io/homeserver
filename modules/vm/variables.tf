variable "linux_vm_size" {
  type        = string
  description = "Size (SKU) of the virtual machine to create"
}

variable "linux_vm_image" {
  type        = map(string)
  description = "Virtual machine source image information"
  default     = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" 
    version   = "latest"
  }
}

variable "linux_admin_username" {
  description = "Username for Virtual Machine administrator account"
  type        = string
}

variable "linux_vm_hostname" {
  description = "Hostname of the Linux VM to create"
  type        = string
}

variable "location" {
  description = "Datacenter region/location"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource grouo name"
  type        = string
}

variable "subnet_id" {
  description = "VM subnet id"
  type        = string
}