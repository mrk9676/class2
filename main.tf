terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.100.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-backedn-storage-accounts"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "ramdevopssa"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "class2"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "class2statefile"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    #use_azuread_auth     = true                            # Can also be set via `ARM_USE_AZUREAD` environment variable.
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


module "resource_group" {
    source = "../modules/azure-resource-group"
    rg_name = "module_testing_rg"
    location = "WestUS"
    tags     = {
        "env" = "dv"
    }
}



module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  # insert the 3 required variables here
  resource_group_name = module.resource_group.rg_name
  use_for_each = false
  vnet_location = var.location
  vnet_name = "module-vnet"
  address_space = ["192.168.0.0/16"]
  subnet_names = [ "subnetA", "subnetB", "subnetC" ]
  subnet_prefixes = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24" ]
}