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
      services.resolved.extraConfig = ''
        [Resolve]
        DNS=100.100.100.100
        Domains=~skunk-ray.ts.net skunk-ray.ts.net
      '';
      services.tailscale = {
        enable = true;
        package = pkgs.tailscale;
        openFirewall = true;
        interfaceName = cfg.interfaceName;
      };

      
      networking.firewall.trustedInterfaces = [ cfg.interfaceName ];

    };

}
