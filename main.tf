
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "c711b549-e84c-45c8-bcb6-fc9ffe839a8c"
  client_id = "f8a37437-1fe1-468a-bce2-37d3eb1ee18f"
  client_secret = "uKO8Q~515O11Wkv5YFQ1dcIXWLBUZ4ujGo2ITciw"
  tenant_id = "8bdd9214-3c6e-41cb-9cca-854954deb7cb"
}

terraform {
  backend "azurerm" {
    storage_account_name = "tfpractisestorage"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "hqlrY8h8WaZgsCfKDcfoC7l8o8ZZDDe4B3Tu8OdSk0x3czpRfSZ9OQDhPQLrgruwoAYEtr+lNjgz48FP6IP1sA=="
  }
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}
resource "azurerm_virtual_network" "vnet1" {
  name                =  "${var.prefix}-10"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  address_space       = ["${var.vnet_cidr_prefix}"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name ="${azurerm_virtual_network.vnet1.name}"
  address_prefixes     = ["${var.subnet1_cidr_prefix}"]
}
resource "azurerm_network_security_group" "nsg2" {
  name                =  "${var.prefix}-nsg2"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "rdp1" {
  name                        = "rdp"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg2.name}"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3388"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
 
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_assoc" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}
resource "azurerm_network_interface" "nic1" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
  depends_on = [
   azurerm_public_ip.example
  ]
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vmt02"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_D2ads_v5"
 
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config { 
    provision_vm_agent = true
  }                       

}
