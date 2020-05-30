resource "azurerm_resource_group" "RGOne" {
  name     = "RGOne"
  location = "East Europe"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_network" "VirtualNetwork" {
  name                = "${var.project_name}vnet"
  location            = "${var.location}"
  address_space       = ["192.168.0.0/16"]
  resource_group_name = "${azurerm_resource_group.RGOne.name}"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_subnet" "Subnet1" {
  name                 = "${var.project_name}subnet"
  virtual_network_name = "${azurerm_virtual_network.VirtualNetwork.name}"
  resource_group_name  = "${azurerm_resource_group.RGOne.name}"
  address_prefixes       = ["192.168.1.0/24"]
}

resource "azurerm_network_interface" "NetworkInterface-nic" {
  name                = "${var.project_name}nic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.RGOne.name}"

  ip_configuration {
    name                          = "${var.project_name}ipconfig"
    subnet_id                     = "${azurerm_subnet.Subnet1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
}

resource "azurerm_public_ip" "pip" {
  name                         = "${var.project_name}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.RGOne.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "esgiterraform"

  tags {
    environment = "Terraform Meetup ESGI"
  }
}

resource "azurerm_storage_account" "stor" {
  name                     = "${var.project_name}-stor"
  location                 = "${var.location}"
  resource_group_name      = "${azurerm_resource_group.RGone.name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_managed_disk" "ManagedDisk" {
  name                 = "${var.project_name}-ManagedDisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.RGone.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_machine" "CentOS" {
  name                  = "${var.project_name}vm"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.RGOne.name}"
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = ["${azurerm_network_interface.NetworkInterface-nic.id}"]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "CentOS7"
    sku       = "7"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.project_name}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${var.project_name}-datadisk"
    managed_disk_id   = "${azurerm_managed_disk.ManagedDisk.id}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "1023"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "VMTerraform"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }
}