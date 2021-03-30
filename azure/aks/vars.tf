#Variables declaration

# variable "subscription_id" {
#   description = "Azure subscription Id."
# }

# variable "tenant_id" {
#   description = "Azure tenant Id."
# }

# variable "client_id" {
#   description = "Azure service principal application Id"
# }

# variable "client_secret" {
#   description = "Azure service principal application Secret"
# }

variable "network_plugin" {
  default = "kubenet"
}

variable "ssh_public_key" {
  description = "Cluster ssh key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "k8s_names" {
  description = "Create AKS with these names"
  type        = list(string)
  default     = ["neo", "trinity"]
}

variable "resource_group_name" {
  default = "rsg-s-aks"
}

variable "aksnodes_resource_group_name" {
  default = "rsg-s-aksnodes"
}

variable "vnet_resource_group_name" {
  default = "we-voydev-rsg-network-voyager-integrationzone"
}

variable "location" {
  default = "westeurope"
}
