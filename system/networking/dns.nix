{ lib, config, ... }:
let
  cfg = config.bluelinden.dns;
in
{
  options = {
    bluelinden = {
      dns = {
        encrypted.enable = lib.mkEnableOption {
          description = "Enable encrypted DNS via DNSCrypt-proxy2";
          type = lib.types.bool;
          default = false;
        };
        resolved.enable = lib.mkEnableOption {
          description = "Enable systemd-resolved";
          type = lib.types.bool;
          default = false;
        };
      };
    };
  };
  config =
    {
      services.dnscrypt-proxy2 = lib.mkIf cfg.encrypted.enable {
          enable = true;
          settings = {
            ipv6_servers = true;
            doh_servers = true;
            require_dnssec = true;
            bootstrap_resolvers = [ "9.9.9.9:53" "8.8.8.8:53" "10.18.81.24:53" ];
            ignore_system_dns = true;
            netprobe_address = "216.58.212.46:80";
            sources.public-resolvers = {
              urls = [
                "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
                "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              ];
              cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            };
            # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
            # server_names = [ ... ];
          };
        };
      services.resolved = lib.mkIf cfg.resolved.enable {enable = true;};
      networking.networkmanager.dns = lib.mkIf cfg.resolved.enable "systemd-resolved";

      systemd.services.dnscrypt-proxy2.serviceConfig = lib.mkIf cfg.encrypted.enable {
          StateDirectory = lib.mkForce "dnscrypt-proxy2";
        };
      };
}

