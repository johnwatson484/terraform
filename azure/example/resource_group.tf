resource "azurerm_resource_group" "rg" {
  name     = "rg_test"
  location = "West US"

  tags = {
    environment = "Terraform Test RG"
  }
}
