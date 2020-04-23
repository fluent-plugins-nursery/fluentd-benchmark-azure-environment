provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

provider "local" {
  version = "~>1.4"
}

resource "azurerm_resource_group" "fluentd" {
  name     = "fluentdBeckmarkResourceGroup"
  location = var.region
}
