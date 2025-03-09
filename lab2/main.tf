terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}
 
provider "azurerm" {
  features {}
}
 
 
resource "azurerm_container_registry" "acr-dev" {
  name                     = "acrdevregistrylab001"
  resource_group_name      = "cal-1327-be0"
  location                 = "West US"
  sku                      = "Standard"
  admin_enabled            = false
 

   provisioner "local-exec" {
    when = destroy
    command = <<EOT
       az acr repository delete --name ${self.name} --image hello-world:calab --yes
    EOT
  }
  
}
 
#Import Container Image to Azure Container Registries
resource "null_resource" "image" {
 
  provisioner "local-exec" {
    command = <<-EOT
       az acr import --name ${azurerm_container_registry.acr-dev.name} --source mcr.microsoft.com/hello-world --image hello-world:calab
    EOT
  }
}