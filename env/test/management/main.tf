terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.23.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateXXXXX" # Azure 全体で重複しない名称をアサイン ($ echo tfstate$RANDOM などで生成)
    container_name       = "tfstate"
    key                  = "management.test.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
