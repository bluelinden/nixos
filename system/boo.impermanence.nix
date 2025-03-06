{
  programs.fuse.userAllowOther = true;

  # everything here should be backed up, and should be considered irreplaceable
  environment.persistence."/data" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/cfg"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    users.blue = {
    
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Projects"
        "Videos"
        ".local/share"
        ".gnupg"
        ".config"
        ".ssh"
        ".pki"
        ".logseq"
      ];
    };
  };

  # anything lost here can be replaced from an installer environment or right when i need it - it's not necessary to keep this stuff in backups. it's just way easier to have it while the computer is alive.
  environment.persistence."/state" = {
    hideMounts = true;
    directories = [
      "/var/cache"
      "/var/lib/AccountsService"
      "/var/lib/NetworkManager"
      "/var/lib/cosmic-greeter"
      "/var/lib/iwd"
      "/var/lib/docker"
      "/var/lib/waydroid"
      "/var/lib/bluetooth"
      "/var/log"

      "/var/lib/alsa"
      "/var/lib/nixos"
      "/var/lib/tailscale"

      "/var/lib/flatpak"
      "/var/lib/flatpak-module"
      "/var/lib/fwupd"
      "/var/lib/libvirt"
      "/var/lib/lockdown"
      "/var/lib/beesd"

      "/etc/secureboot"
      "/etc/oath"

    ];
    files = [
      "/var/lib/alsa/asound.state"
      # "/etc/passwd"
      "/etc/blpw"
      # "/etc/passwd-"
      # "/etc/printcap"
      # "/etc/shadow"
      # "/etc/shadow-"
      "/etc/machine-id"
      # "/etc/subuid"
      # "/etc/subgid"
      # "/etc/sudoers" # <- should remove this at some point
      # "/etc/group"

      "/var/db/sudo/lectured/1000"
      "/var/db/sudo/lectured/blue"
      # { file = "/etc/users.oath"; }
      "/var/lib/usbguard/rules.conf"
    ];

    users.blue = {
      directories = [
        ".cache"
        ".cargo"
        ".conda"
        ".docker"
        ".ghost"
        ".local/bin"
        ".local/lib"
        ".local/state"
        ".local/pipx"
        ".local/zed.app"
        ".mozilla"
        ".zen"
        ".thunderbird"
        ".npm"
        ".steam"
        ".var"
        ".vscode"
        ".vscode-oss"
      ];
      files = [
        ".npmrc"
        ".steampath"
        ".steampid"
        ".yarnrc"
      ];
    };
  };
  fileSystems."/" = {
    fsType = "tmpfs";
    neededForBoot = true;
    options = [
      "defaults"
      "size=16G"
      "mode=755"
    ];
  };

  fileSystems."/home/blue" = {
    device = "none";
    fsType = "tmpfs"; # Can be stored on normal drive or on tmpfs as well
    neededForBoot = true;
    options = [ "defaults" "size=8G" "mode=700" "uid=1000" "gid=100" ];
  };

  fileSystems."/data" = {
    device = "/dev/mapper/boocrypt";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=data"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/state" = {
    device = "/dev/mapper/boocrypt";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=state"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C191-6F86";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/boocrypt";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "subvol=store"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/boocrypt";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "noatime"
      "compress=zstd"
    ];
  };
}
