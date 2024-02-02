# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, specialArgs, ... }:
let
  pkgs = specialArgs.s-nixpkgs;
  upkgs = specialArgs.u-nixpkgs;
  wscribe = upkgs.callPackage (import ./packages/wscribe/default.nix) { };
  webusb-udev = upkgs.callPackage (import ./packages/webusb-udev/default.nix) { };
  niri = upkgs.callPackage (import ./packages/niri/default.nix) { };
  distrobox-patched = upkgs.callPackage (import ./packages/distrobox/default.nix) { };
  localwp = upkgs.callPackage (import ./packages/local/default.nix) { };
  
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      specialArgs.inputs.home-manager.nixosModules.home-manager
      specialArgs.inputs.flatpaks.nixosModules.default
      ./system/networking/dns.nix
      ./system/networking/tailscale.nix
      ./system/networking/base.nix
      ./system/languages.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Bootloader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    # crashDump.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" ];
    initrd.systemd.enable = true;
    initrd.kernelModules = [ "tpm-tis" "i915" ];

    initrd.systemd.emergencyAccess = (import ./emergency-access-password.nix).pwd;
    kernelPackages = upkgs.linuxPackages_xanmod_latest;
    loader.systemd-boot.graceful = true;
    loader.timeout = 0;
    loader.systemd-boot.editor = false;
    loader.grub.memtest86.enable = false;
    loader.grub.device = "/dev/sda";
    loader.grub.efiSupport = true;
    loader.grub.fontSize = 16;

    loader.grub.enable = false;
    loader.grub.font = /home/blue/.local/share/fonts/Lexend-VariableFont_wght.ttf;
    loader.grub.backgroundColor = "#4b1128";
    plymouth.enable = true;
    plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];
    plymouth.theme = "nixos-bgrt";
    loader.systemd-boot.configurationLimit = 30;
    loader.efi.canTouchEfiVariables = true;
    bootspec.enable = true;
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
  };

  console.earlySetup = true;

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];

  networking.hostName = "boo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";



  # networking.nameservers = [ "127.0.0.1" ];

  # networking.networkmanager.wifi.backend = "iwd";

  bluelinden.tailscale.enable = true;
  bluelinden.dns.resolved.enable = true;
  bluelinden.dns.encrypted.enable = true;


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    desktopManager = {
      gnome.enable = true;
    };

    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        banner = ''
          this computer is the property of blue linden. 
        '';

      };
      # sessionPackages = [ niri ];
      autoLogin.enable = false;
    };
  };
  services.tlp.enable = false;

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  services.fwupd.enable = true;

  services.udev.extraHwdb = ''
    EVDEV_ABS_00=::24
    EVDEV_ABS_01=::23
    EVDEV_ABS_35=::24
    EVDEV_ABS_36=::23
  '';


  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    browsing = true;
    drivers = [
      pkgs.canon-cups-ufr2
    ];
  };



  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.opengl = {
  	driSupport32Bit = false;
  	driSupport = true;
  	extraPackages = with pkgs; [
  	  intel-media-driver # LIBVA_DRIVER_NAME=iHD
  	  vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
  	  vaapiVdpau
  	  libvdpau-va-gl
  	];
  };
  security.rtkit.enable = true;
  security.apparmor.enable = true;
  security.audit.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  programs.command-not-found.enable = false;
  programs.nix-ld.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.podman.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blue = {
    isNormalUser = true;
    description = "blue linden";
    extraGroups = [ "networkmanager" "wheel" "configmanager" "plugdev" "libvirtd" ];
  };
  users.groups.configmanager = {
    name = "configmanager";
    members = [ "blue" ];
    gid = 1337;
  };
  users.groups.plugdev = {
    name = "plugdev";
    members = [ "blue" ];
    gid = 990;
  };
  users.defaultUserShell = pkgs.zsh;



  # List packages installed in system profile. To search, run:
  # $ search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    binutils
    rr
    file
    micro
    openjdk17
    dconf2nix
    papirus-icon-theme
    gum
    distrobox-patched
    sbctl
    upkgs.nodejs_21
    upkgs.nodePackages_latest.pnpm
    upkgs.yarn
    upkgs.bun
    hexedit
    localwp
    comma
    libinput
    upkgs.deno
    tpm2-tss
    upkgs.ulauncher
    upkgs.adw-gtk3
    opendrop
    owl
    asciinema
    php81
    php81Packages.composer
    apple-cursor
    stress
    s-tui
    upkgs.logseq
    nixpkgs-fmt
    gnome-network-displays
    tree
    firmware-updater
    dnsmasq
    neofetch
    fastfetch
    qemu
    unzip
    gnumake
    inkscape
    dig
    git-lfs
    upkgs.vscode.fhs
    webusb-udev
    pciutils
    usbutils
    gparted
    steam-run
    maturin
    libimobiledevice
    idevicerestore
    ifuse
    niri
    clang
    # python310Full
    # python310Packages.pip
    # python310Packages.setuptools
    nix-init
    # wscribe
    specialArgs.inputs.nix-software-center.packages.${system}.nix-software-center
    specialArgs.inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
    specialArgs.inputs.nix-alien.packages.${system}.nix-alien
  ];
  environment.binsh = "${pkgs.dash}/bin/dash";

  environment.gnome.excludePackages = with pkgs.gnome; [
    gnome-software
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 21d";
  };
  nix.extraOptions = ''
    min-free = ${toString (5 * 1024 * 1024 * 1024)}
    max-free = ${toString (15 * 1024 * 1024 * 1024)}
  '';
  appstream.enable = true;
  programs.zsh.zsh-autoenv.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.thefuck.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  zramSwap.enable = true;
  powerManagement.cpufreq.min = 100000;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  location.provider = "geoclue2";
  # systemd.sleep.extraConfig = ''
  #   HibernateMode=shutdown
  #   SuspendState=freeze
  # '';
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.tmpfiles.rules = [
    "d /cfg 1774 root configmanager"
  ];

  # home manager config!
  home-manager = {
    useGlobalPkgs = true;
    users = {
      blue = import ./home/blue/home.nix { specialArgs = specialArgs; };
    };
  };

  services.flatpak = {
    enable = true;
    enable-debug = true;
    target-dir = "/var/lib/flatpak";
    remotes = {
      "gnome-nightly" = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
      "gradience-nightly" = "https://gradienceteam.github.io/Gradience/index.flatpakrepo";
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "gradience-nightly:app/com.github.GradienceTeam.Gradience.Devel/x86_64/master"
      "flathub:app/net.hovancik.Stretchly/x86_64/stable"
      "flathub:app/io.missioncenter.MissionCenter/x86_64/stable"
    ];
  };
}
