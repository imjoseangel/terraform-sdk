resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = "West US 2"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  count                           = length(var.k8s_names)
  name                            = "${random_pet.prefix.id}-${var.k8s_names[count.index]}-aks"
  location                        = azurerm_resource_group.default.location
  resource_group_name             = azurerm_resource_group.default.name
  dns_prefix                      = "${random_pet.prefix.id}-${var.k8s_names[count.index]}-k8s"
  api_server_authorized_ip_ranges = ["0.0.0.0/0"]

  default_node_pool {
    name                = "agentpool"
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    enable_auto_scaling = true
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2", "3"]
    max_count           = 15
    min_count           = 3
    os_disk_size_gb     = 128
  }

  linux_profile {
    admin_username = "k8s"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  addon_profile {
    oms_agent {
      enabled = false
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = var.network_plugin
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Demo"
  }
}
