# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for VM
resource "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_subnet.subnet]
  name                = "my-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# **Linux VM with Bastion Access**
resource "azurerm_linux_virtual_machine" "vm" {
  depends_on                      = [azurerm_network_interface.nic, azurerm_subnet.subnet, azurerm_virtual_network.vnet, azurerm_resource_group.rg]
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_D4s_v3" # At least 8GB RAM and 4 vCPU
  admin_username                  = "adminuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false
  custom_data = filebase64("cloud-init.yaml")

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Custom Data - Script to install Flowise & LangChain automatically
  #custom_data = filebase64("install-script.sh")

  tags = {
    environment = "development"
  }
}
