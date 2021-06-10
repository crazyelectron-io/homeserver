# Get a Static Public IP
resource "azurerm_public_ip" "linux-vm-ip" {
  name                = "${var.linux_vm_hostname}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Create Network Card for linux VM
resource "azurerm_network_interface" "linux-vm-nic" {
  name                = "${var.linux_vm_hostname}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip.id
  }
}

## Create Linux virtual machine
resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                  = "${var.linux_vm_hostname}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
  size                  = var.linux_vm_size

  source_image_reference {
    offer     = lookup(var.linux_vm_image, "offer", null)
    publisher = lookup(var.linux_vm_image, "publisher", null)
    sku       = lookup(var.linux_vm_image, "sku", null)
    version   = lookup(var.linux_vm_image, "version", null)
  }

  os_disk {
    name                  = "${var.linux_vm_hostname}-disk"
    caching               = "ReadWrite"
    storage_account_type  = "Premium_LRS"
  }
#  storage_os_disk {
#    name              = format("%s%03d-%s", local.base_hostname, each.value.index, "osdisk")
#    caching           = "ReadWrite"
#    create_option     = "FromImage"
#    managed_disk_type = var.storage_type
#    disk_size_gb      = local.os_disk_size  ######
#    os_type           = "Linux"
#  }

  computer_name  = "${var.linux_vm_hostname}-vm"
  admin_username = var.linux_admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username    = var.linux_admin_username
    public_key  = file("~/.ssh/beheerder_key.pub")
  }

#  boot_diagnostics {
#    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
#  }

#  tags = {
#    environment = "Terraform Demo"
#  }
}

#  dynamic "os_profile_linux_config" {
#    content {
#      disable_password_authentication = true
#      ssh_keys {
#        path     = format("/home/%s/.ssh/authorized_keys", var.admin_username)
#        key_data = file(local.ssh_key_path)
#      }
#    }
#  }
#
#  os_profile {
#    computer_name  = each.value.full_name
#    admin_username = var.admin_username
#    admin_password = null
#  }
