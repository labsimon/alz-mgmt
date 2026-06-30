module "hub_and_spoke_vnet" {
  # Vendored from Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm v0.17.2.
  # Local fork adds an ip_tags passthrough on the firewall public IPs so the
  # platform-injected FirstPartyUsage=/Unprivileged tag (MCAP/sponsored subscriptions)
  # does not force a (blocked) public IP replacement on every apply.
  source = "./modules/connectivity-hub-and-spoke-vnet"

  count = local.connectivity_hub_and_spoke_vnet_enabled ? 1 : 0

  hub_and_spoke_networks_settings = local.hub_and_spoke_networks_settings
  hub_virtual_networks            = local.hub_virtual_networks
  enable_telemetry                = var.enable_telemetry
  tags                            = coalesce(module.config.outputs.connectivity_tags, module.config.outputs.tags)

  providers = {
    azurerm = azurerm.connectivity
    azapi   = azapi.connectivity
  }
}
