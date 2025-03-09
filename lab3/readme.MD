# Terraform Remote State in Azure

## Introduction

Terraform state is stored locally by default in a terraform.tfstate file. With remote state, Terraform writes to a state file hosted in a remote data store. This provides a few advantages over a local state file like security, version control, and centralized storage. It also provides state locking, which is where only one person can modify the state file at a time, which prevents teammates from writing over each other. In Azure you can use a Storage Account for storing the state file as well as state locking.

## State Storage
 
The remote state file will be stored in this Storage Account. Storing the state remotely is great for centralized storage and eliminates the risk of multiple teammates working from the same state file at the same time. If you understand how state works, you know that this would cause major issues when managing Terraform resource with state. State locking is a feature that prevents that state from being opened when it is already in use and is a feature native to Azure Blob Storage.

## Setup Instructions

### Creating Storage Account and Blob Container

Use the following commands to create a Storage Account and blob container:
 
```bash
az storage account create --name sasacal34473e688 --resource-group cal-3447-3e6 --location westus --sku Standard_LRS --encryption-services blob
 
az storage container create --name calab --account-name sasacal34473e688 --auth-mode login
```

### Enabling Version Tracking

To enable version tracking on the storage account:
 
```bash
az storage account blob-service-properties update -n sasacal34473e688 --enable-change-feed true --enable-versioning true
```

### Viewing the State File

To view the state file inside of the Storage Account:
 
```bash
key=$(az storage account keys list -g cal-3447-3e6 -n sasacal34473e688 --query [0].value -o tsv)
 
az storage blob list --container-name calab --account-name sasacal34473e688 --account-key $key
```

## Terraform Configuration

The resource blocks contain the infrastructure to create with Terraform, in this lab it is just a simple Virtual Network and subnet. 
The `backend` block refers to how Terraform operates with the state file. By default, the local backend is used, but creating a `backend` block within the `terraform` configuration block tells Terraform to use a Storage Account to store the state file.

## Naming Considerations

It is important to use well thought out naming standards for the `key` argument. With advanced Terraform configurations, it is not uncommon to retrieve data from other states, and having solid naming in place will complement this process. The `key` argument includes the path and name of the state file.

## State Locking

During the terraform apply, the state file is locked. The Azure Blob Storage is holding the lock status of the file. If another user were to run terraform apply using the same remote state file right now, they would get a lock error. This is great to prevent multiple users from modifying the same infrastructure at once.

## State File Location

The container `calab` is shown with a blob file `dev.terraform.tfstate` which is the state file specified in the Terraform configuration.

## Summary

In this lab step, you created an Azure Storage Account and used it to configure remote state for a terraform configuration.

## Benefits of Remote State

- **Centralized Storage**: Easy access for team members and CI/CD pipelines
- **Version Control**: Track changes to your state with blob versioning
- **Security**: Better access controls than local files
- **State Locking**: Prevents concurrent modifications and conflicts
- **Disaster Recovery**: Backups and versioning provide protection against data loss

## Best Practices

1. Always use remote state for team environments
2. Implement RBAC controls on the storage account
3. Use meaningful state file naming conventions
4. Consider separate state files for different environments or components
5. Enable versioning for easier troubleshooting and recovery