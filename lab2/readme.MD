# Azure Container Registry with Docker Image Import

This Terraform configuration automatically provisions an Azure Container Registry (ACR) and imports a Docker image into the registry.

## Overview

This configuration demonstrates:
1. Creation of an Azure Container Registry in your specified Resource Group
2. Automated import of a Docker image to the container registry using `null_resource` and provisioners
3. Proper cleanup during resource destruction

## Prerequisites

- Terraform installed
- Azure CLI installed and configured with appropriate permissions
- Active Azure subscription
- Existing Resource Group

## How It Works

### Infrastructure Creation

The `main.tf` file contains:
- An Azure Container Registry resource definition
- A `null_resource` with provisioner blocks for image import

### Execution Process

When you run `terraform apply`:
1. The ACR resource is created in your Azure Resource Group
2. The `null_resource` detects the ACR creation (implicit dependency)
3. The provisioner commands execute locally, importing the hello-world image to the registry

When you run `terraform destroy`:
1. The destroy provisioner executes to clean up the image
2. The ACR resource is destroyed

## Important Notes

### Local Dependencies

⚠️ **Warning**: This configuration requires the Azure CLI to be installed on the machine executing Terraform. This creates a local execution dependency, making the configuration less portable.

### Provisioner Best Practices

While provisioners are powerful, they have limitations:
- They create external dependencies
- They may not provide proper error handling in all cases
- They can complicate state management

### Alternative Approaches

For production environments, consider:
- Using Azure DevOps pipelines or other CI/CD tools to handle image deployment
- Separating infrastructure provisioning (Terraform) from application deployment (CI/CD)
- Using Azure Container Registry Tasks for image building and management

### Side Notes

The reference to the ACR repository name creates an implicit dependency, opens in a new tab inside the provisioner block that is telling Terraform to create the null_resource block and run the provisioner block after the ACR resource has been created
 
You can see that the ACR resource is created and then the provisioner block commands are executed pushing the hello-world image up to the repository. The provisioner allows us to automate more than just the ACR resource in Terraform and create infrastructure code that produces exactly what is needed in one command.

You can add provisioner blocks inside of resources. However, it's best practice to create a null resource block when possible. This provisioner block also has the when = destroyattribute, which tells Terraform to run this only when the resource is being destroyed. Also, the self.name is being interpolated within the provisioner block to reference the name of the ACR resource.
Running terraform destroy will execute the commands inside the provisioner block and delete the image before deleting the ACR resource. This is a redundant step as the image will automatically be deleted when the ACR resource is destroyed, but it is used for demonstration purposes.
 
Keep in mind that provisioners are extremely useful for adding additional tasks to deploying and destroying resources. However, provisioners should be a last resource because it adds complexity to Terraform code and can make it brittle. It's best to seek alternative solutions before using provisioners. In this example, instead of pushing the docker image through a Terraform provisioner, it would be best to use a CI/CD tool like Azure DevOps or Jenkins to perform that task and let the Terraform code handle the infrastructure. 

## Conclusion

In this lab step, I created a provisioner to upload a Docker image to an ACR resource after it was provisioned. I also created a destroy provisioner to perform clean up tasks when the ACR was destroyed.