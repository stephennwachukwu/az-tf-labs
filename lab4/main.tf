# Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}
 
#Azure provider
provider "azurerm" {
  features {}
}
 
#Create Storage Account
module "storage_account" {
  source    = "./modules/storage-account"
 
  saname    = "sacal13391141"
  rgname    = "cal-1339-114"
  location  = ""
}
module "storage_account2" {
  source    = "./modules/storage-account"
 
  saname    = "sacal13391142"
  rgname    = "cal-1339-114"
  location  = "westus"
}

#Create Network Security Groups
module "nsg" {
    count = 3 
    source = "./modules/nsg"
 
    nsgname    = "nsg${count.index}"
    rgname    = "cal-555-226"
    location  = "westus"
 
    nsg_rule = [
      {
      name                       = "http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      },
      {
      name                       = "ssh"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "22"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      },
      {
      name                       = "rdp"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "3389"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }
    ]
}