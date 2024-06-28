{
  programs.fuse.userAllowOther = true;

  # everything here should be backed up, and should be considered irreplaceable
  environment.impermanence."/data" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      {
        directory = "/home/blue";
        user = "blue";
        group = "users";
        mode = "0700";
      }
      "/cfg"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # anything lost here can be replaced from an installer environment or right when i need it - it's not necessary to keep this stuff in backups. it's just way easier to have it while the computer is alive.
  environment.impermanence."/state" = {
    hideMounts = true;
    directories = [
      "/var/cache"
      "/var/lib/AccountsService"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
      "/var/lib/docker"

      "/var/lib/alsa"
      "/var/lib/nixos"
      "/var/lib/tailscale"
      "/var/lib/dnscrypt-proxy2/public-resolvers.md"
      "/var/lib/flatpak"
      "/var/lib/flatpak-module"
      "/var/lib/fwupd"
      "/var/lib/libvirt"
      "/var/lib/lockdown"
      "/var/lib/beesd"

      "/etc/secureboot"

    ];
    files = [
      "/var/lib/alsa/asound.state"
      "/etc/passwd"
      "/etc/passwd-"
      "/etc/printcap"
      "/etc/shadow"
      "/etc/shadow-"
      "/etc/machine-id"
      "/etc/subuid"
      "/etc/subgid"
      "/etc/sudoers" # <- should remove this at some point
      "/etc/group"

    ];
  };
  fileSystems."/" = {
    fsType = "tmpfs";
    neededForBoot = true;
    options = [
      "defaults"
      "size=8G"
      "mode=755"
    ];
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

  fileSystems."/cfg" = {
    device = "/dev/mapper/boocrypt";
    fsType = "btrfs";
    options = [
      "subvol=config"
      "noatime"
      "compress=zstd"
    ];
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
