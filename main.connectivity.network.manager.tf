# Azure Virtual Network Manager (AVNM) + IPAM pool
# -------------------------------------------------
# Deployed into the connectivity subscription and scoped to the Landing Zones
# management group. Vended landing zone subscriptions (see the alz-sub-vending
# repo) allocate non-overlapping spoke address space from the IPAM pool below
# instead of hard-coding CIDR ranges.
#
# Prerequisites:
# - The deploying identity needs access to the management group set in
#   var.network_manager_scope_management_group_id.
# - Spoke deployments need an RBAC role on the IPAM pool that permits the
#   Microsoft.Network/networkManagers/ipamPools allocate actions.

locals {
  network_manager_enabled  = var.network_manager_ipam_enabled
  network_manager_location = coalesce(module.config.outputs.network_manager_location, var.starter_locations[0])
  network_manager_tags     = coalesce(module.config.outputs.connectivity_tags, module.config.outputs.tags)

  network_manager_rg_name        = coalesce(module.config.outputs.network_manager_resource_group_name, "rg-avnm-${local.network_manager_location}")
  network_manager_name           = coalesce(module.config.outputs.network_manager_name, "avnm-${local.network_manager_location}")
  network_manager_ipam_pool_name = coalesce(module.config.outputs.network_manager_ipam_pool_name, "ipam-lz-${local.network_manager_location}")
}

resource "azurerm_resource_group" "network_manager" {
  count = local.network_manager_enabled ? 1 : 0

  name     = local.network_manager_rg_name
  location = local.network_manager_location
  tags     = local.network_manager_tags

  provider = azurerm.connectivity
}

resource "azurerm_network_manager" "this" {
  count = local.network_manager_enabled ? 1 : 0

  name                = local.network_manager_name
  resource_group_name = azurerm_resource_group.network_manager[0].name
  location            = azurerm_resource_group.network_manager[0].location
  tags                = local.network_manager_tags

  scope {
    management_group_ids = [
      "/providers/Microsoft.Management/managementGroups/${var.network_manager_scope_management_group_id}"
    ]
  }

  provider = azurerm.connectivity
}

resource "azurerm_network_manager_ipam_pool" "this" {
  count = local.network_manager_enabled ? 1 : 0

  name               = local.network_manager_ipam_pool_name
  network_manager_id = azurerm_network_manager.this[0].id
  location           = local.network_manager_location
  display_name       = local.network_manager_ipam_pool_name
  address_prefixes   = var.network_manager_ipam_pool_address_prefixes

  provider = azurerm.connectivity
}
