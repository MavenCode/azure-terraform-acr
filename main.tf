# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.resource_group_location
# }

resource "azurerm_container_registry" "acr" {
    name                = var.acr_name
    resource_group_name = var.resource_group_name
    location            = var.resource_group_location

    sku                 = "Premium"

    admin_enabled       = true
}
