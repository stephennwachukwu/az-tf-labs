# Terraform Modules - Storage Account Example

## Introduction

In Terraform, you can create modules to build re-usable infrastructure components. For example, a module can exist for a MySQL environment and a separate one can exist for Virtual Machines. The modules can then be used in combination like building blocks to build and deploy Azure services for various environments. 

In this lab step, you will create a module for deploying a Storage Account and use it in a Terraform configuration.

## Module Structure

The storage module main.tf file contains the resource block for a Storage Account resource. It contains the Storage Account standard configurations to be made into a module. Also, notice that the `required_providers` block is specified. Because the Azure provider is updated so frequently, it's best practice to specify the version that your module is compatible with. Otherwise newer or older versions of the provider may not work with the module and cause issues.

The variables will be used as input for the module to enable the Storage Account to be customized per environment. The module will take the input for storage account name, resource group, and location to allow the module to be deployed to various environments. This makes the module reusable since the environment isn't hardcoded into the Terraform configuration. 

The output block will allow the module to output the primary access key of the Storage Account so it can be passed through to other resources within a Terraform configuration. 

Now, the module has been completed. You'll notice that this looks just like a regular Terraform configuration. Terraform modules are just snippets of code that can be called from within other Terraform configurations. Think of it as how functions are used from a software development perspective. Functions are used to isolate actions or processes in code, which allows them to be tested, decoupled, and reused throughout the application. In Terraform, the concept is still the same, but they are called modules. 

## Using the Module

To use the module within the Terraform configuration, the resource type is declared as a `module` type. The block label can be any name given to the module block. In this example, it's `storage_account`. The arguments that parametrize the module are included in the module block. The `source` argument defines the location of the module that is being used. In this case, it's within the child folders of the directory. Next, the arguments that were declared in the `variables.tf` file are specified.

The Azure provider is downloaded during the initialization process. Also notice the module is initialized. Since the module is sourced locally within a child folder, it is not necessary to download the module. However, modules can be sourced in other places like the Terraform registry and would be downloaded during the initialization phase.

The Storage Account module has been used to deploy the two Storage Accounts. In this example, you created a module and stored it in a child folder. You can also use other sources for modules like version control repositories like GitHub. HashiCorp also has a public module registry called the Terraform Registry, opens in a new tab, which hosts community-made modules. 

## Example Module Files via Azure Storage Account creation

### modules/storage/main.tf
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

### modules/storage/variables.tf
```hcl
variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the storage account is created"
  type        = string
}
```

### modules/storage/outputs.tf
```hcl
output "primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}
```

## Example Root Configuration

### main.tf
```hcl
provider "azurerm" {
  features {}
}

module "storage_account" {
  source               = "./modules/storage"
  storage_account_name = "storageaccount1"
  resource_group_name  = "example-resources"
  location             = "eastus"
}

module "storage_account_2" {
  source               = "./modules/storage"
  storage_account_name = "storageaccount2"
  resource_group_name  = "example-resources"
  location             = "westus"
}
```

## Summary

In this lab step, you created a module for deploying Storage Accounts and called the module within a Terraform configuration file.