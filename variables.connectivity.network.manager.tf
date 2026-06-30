variable "network_manager_ipam_enabled" {
  type        = bool
  default     = true
  description = "Deploy an Azure Virtual Network Manager and IPAM pool in the connectivity subscription for spoke address allocation."
}

variable "network_manager_name" {
  type        = string
  default     = null
  description = "Name of the Azure Virtual Network Manager. Defaults to avnm-<location>."
}

variable "network_manager_resource_group_name" {
  type        = string
  default     = null
  description = "Resource group (in the connectivity subscription) that holds the Azure Virtual Network Manager. Defaults to rg-avnm-<location>."
}

variable "network_manager_location" {
  type        = string
  default     = null
  description = "Location for the Azure Virtual Network Manager. Defaults to the first starter location."
}

variable "network_manager_scope_management_group_id" {
  type        = string
  default     = "landingzones"
  description = "Management group ID the Network Manager is scoped to. All landing zone subscriptions under it can allocate from the IPAM pool."
}

variable "network_manager_ipam_pool_name" {
  type        = string
  default     = null
  description = "Name of the IPAM pool. Defaults to ipam-lz-<location>."
}

variable "network_manager_ipam_pool_address_prefixes" {
  type        = list(string)
  default     = ["10.16.0.0/12"]
  description = "Parent address space the IPAM pool carves spoke ranges from. Must not overlap the hub address space (default hub is 10.0.0.0/16)."
}
