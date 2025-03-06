# Public IP for Bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = var.bastion_ip
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
