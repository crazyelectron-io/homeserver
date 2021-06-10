output "storage_account_name" {
    value = azurerm_storage_account.sa.name
}

output "resouce_group_name" {
    value = azurerm_resource_group.setup.name
}