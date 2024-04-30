{ config, lib, pkgs, ... }:

let
  cfg = config.services.ydotool;
in

{

  options = {
    services.ydotool = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        ydotool, a generic Linux command-line automation tool. Make sure to add your user to the input group:
        `users.users.alice.extraGroups = [ "input" ];`
      '');
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.ydotool ];

    systemd.user.services.ydotoold = {
      description = "Daemon for ydotool";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "always";
      };
    };
  };
}
