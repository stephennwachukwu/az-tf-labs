# Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "cal-3447-3e6"
    storage_account_name = "sasacal34473e688"
    container_name       = "calab"
    key                  = "dev.terraform.tfstate"
  }
}
#Azure provider
provider "azurerm" {
  features {}
}

###################################
#Create virtual network 1
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-dev-westus-001"
  address_space       = ["10.0.0.0/16"]
  location            = "westus"
  resource_group_name = "cal-3388-2d2"
}
# Create subnet 1
resource "azurerm_subnet" "subnet1" {
  name                 = "snet1-dev-westus-001"
  resource_group_name  = "cal-3388-2d2"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.3.0/24"]
}

#######################################
#Create virtual network 2
resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2-dev-westus-001"
  address_space       = ["10.1.0.0/16"]
  location            = "westus"
  resource_group_name = "cal-3388-2d2"
}
# Create subnet 2
resource "azurerm_subnet" "subnet2" {
  name                 = "snet2-dev-westus-001"
  resource_group_name  = "cal-3388-2d2"
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
}