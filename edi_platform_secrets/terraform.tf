terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}

  #subscription_id = "74d03f75-4bdb-4666-8095-500178a40764"
  #client_id       = "39b16fab-b018-4028-8ce7-15c7ef3bfe62"
  #client_secret   = var.arm_client_secret
  #tenant_id       = "1a407a2d-7675-4d17-8692-b3ac285306e4 "
}