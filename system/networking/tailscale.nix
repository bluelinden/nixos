{ pkgs, lib, config, ... }:
let cfg = config.bluelinden.tailscale;
in
{
  options = {
    bluelinden = {
      tailscale = {
        enable = lib.mkEnableOption
          {
            description = "Enable blue linden's Tailscale config";
            type = lib.types.bool;
            default = false;
          };
        interfaceName = lib.mkOption
          {
            description = "Tailscale interface name";
            type = lib.types.str;
            default = "bluenet0";
          };
        domains = lib.mkOption
          {
            description = "Tailscale domain";
            type = lib.types.listOf lib.types.str;
            default = [ "skunk-ray.ts.net" ];
          };
      };
    };

  };
  config =
    lib.mkIf cfg.enable {
      networking.search = cfg.domains;
      # networking.nameservers = [ "127.0.0.1" ];
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        openFirewall = true;
        interfaceName = cfg.interfaceName;
      };

      systemd.services.resolved-patch = {
        after = ["systemd-resolved.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          execStart = ''
            resolvectl domain bluenet0 skunk-ray.ts.net
            resolvectl dns bluenet0 100.100.100.100
          '';
        };
      };

      powerManagement.resumeCommands = ''
        resolvectl domain bluenet0 skunk-ray.ts.net
        resolvectl dns bluenet0 100.100.100.100
      '';
      
      networking.firewall.trustedInterfaces = [ cfg.interfaceName ];

    };

}
