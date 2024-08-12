{ pkgs, ... }: {
  services.restic = {
    enable = true;
    backups = {
      primary = {
        user = "restic";
        environmentFile = "/data/meta/restic.env";
        paths = [
          "/data"
        ];
        initialize = true;
        pruneOpts = [
          "--keep-within-hourly 9h"
          "--keep-within-daily 7d"
          "--keep-within-weekly 5w"
          "--keep-within-monthly 12m"
          "--keep-within-yearly 75y"
          "--max-unused 10G"
        ];
        timerConfig = {
          OnBootSec = "hourly";
          OnActiveSec = "01:25:00";
          RandomizedDelaySec = "20m";
        };
        checkOpts = [ "--with-cache" ];
        extraBackupArgs = [
          "--exclude-if-present=.nobak"
          "--exclude-caches"
        ];
        exclude = [
          ".git"
          "node_modules"
          "target"
          "build"
          "result"
          ".devenv"
          "/data/home/*/.local/share/Steam"
          "/data/home/*/.local/share/docker"
          "/data/home/*/.local/share/zed/languages"
          "/data/home/*/.local/share/Trash"
          "/data/home/*/.local/share/backgrounds"
          "/data/home/*/.local/share/pnpm"
          "/data/home/*/.local/share/fonts"
          "/data/home/*/Downloads/*.iso"
          "/data/home/*/Downloads/*.img"
          "/data/home/*/Downloads/*.deb"
          "/data/home/*/.config/vivaldi"
          "Cache"
          "CachedData"
          "cache"
          ".npm/_cacache"
          ".bun/install/cache"
          ".mozilla/firefox"
        ];

      };
    };
  };
  users.users.restic = {
    isSystemUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };
}
