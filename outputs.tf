output "admin_password" {
    value       = azurerm_container_registry.acr.admin_password
    description = "The object ID of the user"
    sensitive   = true
}

output "id" {
    value       = azurerm_container_registry.acr.id
    description = "acr resource id"
}
