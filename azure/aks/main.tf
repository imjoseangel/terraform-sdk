resource "random_pet" "prefix" {}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
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
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  linux_profile {
      admin_username = "k8s"

      ssh_key {
          key_data = file(var.ssh_public_key)
      }
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
      oms_agent {
      enabled     = false
      }
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
  }

  tags = {
    environment = "Demo"
  }
}
