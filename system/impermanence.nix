{
  fileSystems."/" =
    {
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "size=8G" "mode=755" ];
    };

  fileSystems."/data" =
    {
      device = "/dev/mapper/boocrypt";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=root" ];
    };


  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/C191-6F86";
      fsType = "vfat";
    };

  fileSystems."/cfg" =
    {
      device = "/dev/mapper/boocrypt";
      fsType = "btrfs";
      options = [ "subvol=config" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/mapper/boocrypt";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/mapper/boocrypt";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=store" ];
    };

  fileSystems."/swap" =
    {
      device = "/dev/mapper/boocrypt";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };
}
