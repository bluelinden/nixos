{ pkgs, ... }: {
  services.restic = {
    backups = {
      primary = {
        user = "restic";
        passwordFile = "/data/meta/backups/restic.primary.password";
        repositoryFile = "/data/meta/backups/restic.primary.repo";
        environmentFile = "/data/meta/backups/restic.primary.env";
        paths = [
          "/data"
        ];
        initialize = true;
        pruneOpts = [
          "--keep-within-hourly 18h"
          "--keep-within-daily 7d"
          "--keep-within-weekly 35d"
          "--keep-within-monthly 12m"
          "--keep-within-yearly 75y"
          "--max-unused 10G"
        ];
        timerConfig = {
          OnCalendar = "*-*-* 0..23/1:00:00";
          Persistent = true;
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
          "/data/etc/NetworkManager"
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

  systemd.services.restic-backups-primary.serviceConfig.AmbientCapabilities = [
    "CAP_DAC_READ_SEARCH"
  ];

  users.users.restic = {
    isSystemUser = true;
    group = "restic";
  };
  users.groups.restic = { };
}
