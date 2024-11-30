{ ... }:
{
  # Enable networking and tailscale
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.backend = "iwd";

  # networking.networkmanager.dns = lib.mkForce "default";
  # networking.nftables.enable = true;
  services.avahi.enable = true;

  services.geoclue2.enable = true;
  services.gvfs.enable = true;
  services.gnome.glib-networking.enable = true;
}
