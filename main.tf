terraform {
  required_version = ">= 0.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.50.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

#---Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = merge(var.default_tags, tomap({ "type" = "resource" }))
}

module "application_vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = merge(var.default_tags, tomap({ "type" = "network" }))
  vnet_name           = "${var.name_prefix}-vnet"
  address_space       = var.address_space
}

module "application_subnets" {
  source              = "./modules/subnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = merge(var.default_tags, tomap({ "type" = "network" }))
  vnet_name           = module.application_vnet.vnet_name

  subnets = [
    {
      name   = "${azurerm_resource_group.rg.name}-subnet"
      prefix = var.subnet
    }
  ]
}

module "network_security_group" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.rg.name
  name                = "${var.name_prefix}-nsg"
  location            = var.location
}

module "network_security_rules" { 
  source    = "./modules/nsg_rule"
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = module.network_security_group.name
  location  = var.location
  rules_map = {
    rule1 = {
      name = "SSH",
      priority = 105,
      direction = "Inbound",
      access = "Allow",
      protocol = "TCP",
      source_port_range = "*",
      destination_port_range = "22",
      source_address_prefix = var.default_ip_whitelist,
      destination_address_prefix = "*",
      network_security_group_name = module.network_security_group.name
    },
    rule2 = {
      name = "HTTP",
      priority = 110,
      direction = "Inbound",
      access = "Allow",
      protocol = "TCP",
      source_port_range = "*",
      destination_port_range = "80",
      source_address_prefix = var.default_ip_whitelist,
      destination_address_prefix = "*",
      network_security_group_name = module.network_security_group.name
    },
    rule3 = {
      name = "HTTPS",
      priority = 115,
      direction = "Inbound",
      access = "Allow",
      protocol = "TCP",
      source_port_range = "*",
      destination_port_range = "443",
      source_address_prefix = var.default_ip_whitelist,
      destination_address_prefix = "*",
      network_security_group_name = module.network_security_group.name
    }
  }
}

module "virtual_machine" {
  source                = "./modules/vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  linux_vm_size         = var.vm_size
  linux_vm_image        = {
      "offer"       = "UbuntuServer",
      "publisher"   = "Canonical",
      "sku"         = "18.04-LTS",
      "version"     = "latest"
  }
  linux_admin_username  = "beheerder"
  linux_vm_hostname     = "${var.name_prefix}-vm"
  subnet_id           = module.application_subnets.vnet_subnets
}