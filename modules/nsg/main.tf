resource "azurerm_network_security_group" "nsg" {
  name                = format("%s-nsg", lower(var.name))
  location            = var.location
  resource_group_name = var.resource_group_name
}
