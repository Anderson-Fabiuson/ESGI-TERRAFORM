resource "azurerm_resource_group" "RGMonoVM" {
  name = "RGMonoVM"
  location = "northeurope"

  tags {
    environment = "ressouceGroup"
  }
}