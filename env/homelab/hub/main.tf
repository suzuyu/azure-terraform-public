terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.89.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateXXXXX" # Azure 全体で重複しない名称をアサイン ($ echo tfstate$RANDOM などで生成)
    container_name       = "tfstate"
    key                  = "hub.homelab.terraform.tfstate"
  }

}

provider "azurerm" {
  # subscription_id = "" # This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.
  # client_id       = "" # This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  # tenant_id       = "" # This can also be sourced from the ARM_TENANT_ID Environment Variable.
  # client_secret   = "" # This can also be sourced from the ARM_CLIENT_SECRET Environment Variable.
  features {}
}
