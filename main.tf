terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
tenant_id = ""
subscription_id = ""
client_id = ""
client_secret = ""

  # skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}
resource "azurerm_resource_group" "myrg1" {
    name = "muraleerg"
    location = "central India"
}

 # creating a virtual network 
 resource "azurerm_virtual_network" "myvnet1" {
  resource_group_name = azurerm_resource_group.myrg1.name
  location = azurerm_resource_group.myrg1.location
  address_space = ["192.168.0.0/16"]
  name = "vnet01"
  
   
 }

#  create a virtual machine 
resource "azurerm_linux_virtual_machine" "myvm1" {
  name = "ubuntuvm"
  size = "Standard_B1s"
  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  admin_username = "vijay"
  admin_password = "Hello@password"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.myintf.id]
  #network_interface_ids = azurerm_network_interface.myintf
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    
      }
    source_image_reference {
      

        publisher = "Canonical"
        offer   = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
      

  
}
resource "azurerm_subnet" "subnet99" {
  name                 = "subnet22"
  resource_group_name  = azurerm_resource_group.myrg1.name
  virtual_network_name = azurerm_virtual_network.myvnet1.name
  address_prefixes     = ["192.168.10.0/24"]
}

# network interface for ubuntuvm
resource "azurerm_network_interface" "myintf" {
  name = "chutiya"
  location = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
  ip_configuration {
    name                          = "mytest1"
    subnet_id = azurerm_subnet.subnet99.id

    private_ip_address_allocation = "Dynamic"
  }

}