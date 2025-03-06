resource "azurerm_subnet" "bastion_subnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.bastion_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.2.0/24"]
}

# Azure Bastion Service
resource "azurerm_bastion_host" "bastion" {
  depends_on          = [azurerm_subnet.bastion_subnet]
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}

