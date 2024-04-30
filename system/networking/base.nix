{ ... }:
{
  # Enable networking and tailscale
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  # networking.networkmanager.dns = lib.mkForce "default";
  # networking.nftables.enable = true;
}
