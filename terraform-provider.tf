terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.21.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "zelectric-rg"
    storage_account_name = "zelectricstorageacc"
    container_name       = "tfstate"
    key                  = "vm.terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "01b89ee8-caef-4e87-ab38-ab8c27a7da58"
}