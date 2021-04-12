resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = var.location

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_resource_group" "vnet" {
  name     = var.vnet_resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-aks"
  address_space       = ["10.100.0.0/23"]
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.vnet.name
  tags = {
    "env"    = "demo"
    "object" = "vnet"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-aksnodes"
  address_prefixes     = ["10.100.0.0/24"]
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_kubernetes_cluster" "default" {
  count                           = length(var.k8s_names)
  name                            = "${random_pet.prefix.id}-${var.k8s_names[count.index]}-aks"
  location                        = azurerm_resource_group.default.location
  resource_group_name             = azurerm_resource_group.default.name
  node_resource_group             = var.aksnodes_resource_group_name
  dns_prefix                      = "${random_pet.prefix.id}-${var.k8s_names[count.index]}-k8s"
  api_server_authorized_ip_ranges = ["0.0.0.0/0"]

  default_node_pool {
    name                = "agentpool"
    node_count          = 3
    vm_size             = "Standard_D2s_v3"
    vnet_subnet_id      = azurerm_subnet.subnet.id
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

resource "azurerm_role_assignment" "aks" {
  count                = length(var.k8s_names)
  scope                = azurerm_subnet.subnet.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.default[count.index].identity[0].principal_id
}
resource "azurerm_role_assignment" "aks_subnet" {
  count                = length(var.k8s_names)
  scope                = azurerm_subnet.subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.default[count.index].identity[0].principal_id
}
