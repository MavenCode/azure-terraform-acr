# Azure Terraform ACR (Azure Container Registry)  

Azure Container Registry allows you to build, store and manage container images in a private registry.  

This repository encapsulates the Azure Container Registry module configuration files, defined in terraform scripts.  

The terraform configuration files are defined in the `main.tf`, `outputs.tf` and `variables.tf` files.  

The `main.tf` file defines the state of the Azure Container Registry to be created in the Azure platform.  

The `outputs.tf` file define the output parameters.  

The `variables.tf` files declares the variables used in the other files.  

To use this module from another repository, you need to create a `main.tf` file that will reference this repository as a source.  

## Create Terraform configuration files  
Create a file named `main.tf` and insert the following code:  

```  
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}  

module <"name_of_module"> {
    source = "github.com/MavenCode/azure-terraform-acr"  
    resource_group_name = azurerm_resource_group.rg.name  
    resource_group_location = azurerm_resource_group.rg.location
}  
```  

Update the `<"name_of_module">` with a reference name for the module.  

Create a file named `provider.tf` and insert the following codes:  

```  
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.65"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  client_id         = var.client_id
  client_secret     = var.client_secret
}  
```  

Create a file named `variables.tf` and insert the following codes:  

```  
variable "resource_group_name" {
    description = "Name of Azure resource group"
}  

variable "resource_group_location" {
    description = "Location of Azure resource group"
}  

variable "subscription_id" {}  

variable "tenant_id" {}  

variable "client_id" {}  

variable "client_secret" {}  
```  

## Executing the configurations from a local machine with Terraform  
Steps:  
1.  Install the latest version of Terraform to your machine:  

    Follow the instructions outlined in the [Terraform CLI installation documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli "install Terraform CLI") to download Terraform. Terraform CLI download file comes in `zip` format.  

2.  Unzip the file and move the executable file to your system's `PATH`  

3.  Clone the repository hosting the Terraform files you created from the above step.  

4.  Initialize Terraform in the root directory of the repo by running the following command.  

    ```  
    terraform init  
    ```  
    This downloads the module from this repository, save it in your local directory. It also download the Azure modules in the configuration files.  

5.  Validate the Terraform configurations by running the following commands:  

    ```  
    terraform validate  
    ```  
    Terraform goes through the configuration files to validate the scripts.  

6.  Create Terraform execution plan by running the following command:  

    ```  
    terraform plan  
    ```  
    This determines the actions necessary to create the resources in the terraform configuration files.  

7.  Execute the Terraform plan by running the following command:  

    ```  
    terraform apply  
    ```  

## Executing the configurations with Terraform from github via github actions  
The configuration files can be applied from the git repository you are working with using git actions.  

Steps:  
1.  Create a path in your repository named `.github/workflows/<file_name>.yaml`:  

    Update `<file_name>` with the name of the `yaml` file for housing the git actions configuration files.  

2.  Configure Azure credentials:  
    To fetch the credentials for authenticating with Azure, run the following command in Azure CLI.  

    ```  
    az ad sp create-for-rbac --name <service_principal_name> --role Contributor  
    ```  

3.  Create git secrets with the outputs of the step above: subscription_id, tenant_id, principal_id and principal_password.

4.  Insert the following codes into the file you created.  

```  
name: Deploy and configure Azure Container Registry in Azure with Terraform

on:
  push:
    branches:
    - main

jobs:
  setup-install:
    name: Setup, Install
    runs-on: ubuntu-latest

    defaults:
      run:
        shell: bash
    
    env:
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
      AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS }}

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Azure CLI script
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az account show
          az storage -h
    
    - name: Install Terraform  
      run: |-
        curl -O https://releases.hashicorp.com/terraform/1.1.4/terraform_1.1.4_linux_amd64.zip  
        unzip terraform_1.1.4_linux_amd64.zip
    
    - name: Terraform Init 
      run: |-
        terraform init
    - name: Terraform Validate
      run: |-
        terraform Validate
    - name: Terraform Plan
      run: |-
        terraform plan
    - name: Terraform Apply
      run: |-
        terraform apply --auto-approve  
```