resource "azurerm_linux_virtual_machine" "Deep-vm" {
  name                            = "dev-machine"
  resource_group_name             = azurerm_resource_group.Deep-rg.name
  location                        = azurerm_resource_group.Deep-rg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = "JenkinsPass@20"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.Deep-NIC.id, ]

  custom_data = filebase64("customdata.tpl")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }
}

#provisioner "local-exec" {
#command = templatefile("${var.host_os}-ssh-script.tpl", {
# hostname     = self.public_ip_address,
#user         = "adminuser",
#identityfile = "~/.ssh/tfazkey"
#})
#
#interpreter = var.host_os == "windows" ? ["PowerShell", "-Command"] : ["bash", "-c"]
#}



#data "azurerm_public_ip" "Deep-ip-data" {
# name                = azurerm_public_ip.Deep-ip.name
#resource_group_name = azurerm_resource_group.Deep-rg.name
#}

#output "public_ip_address" {
# value = "${azurerm_linux_virtual_machine.Deep-vm.name}: ${data.azurerm_public_ip.Deep-ip-data.ip_address}"
#}
