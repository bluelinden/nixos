# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, specialArgs, ... }:
let pkgs = specialArgs.s-nixpkgs; upkgs = specialArgs.u-nixpkgs; bun-baseline = upkgs.callPackage ( import ./packages/bun-baseline/default.nix ) {}; inkscape-updated = upkgs.callPackage ( import ./packages/inkscape-1.3/default.nix ) {}; wscribe = upkgs.callPackage (import ./packages/wscribe/default.nix) {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      specialArgs.inputs.home-manager.nixosModules.home-manager
      specialArgs.inputs.flatpaks.nixosModules.default
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.crashDump.enable = true;
  boot.initrd.verbose = false;
  boot.kernelPackages = upkgs.linuxPackages_xanmod_latest;
  boot.loader.systemd-boot.graceful = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.editor = false;
  boot.loader.grub.memtest86.enable = false;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.fontSize = 16;
  boot.loader.grub.enable = false;
  boot.loader.grub.font = /home/blue/.local/share/fonts/Lexend-VariableFont_wght.ttf;
  boot.loader.grub.backgroundColor = "#4b1128";
  boot.plymouth.enable = true;
  boot.plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    {
      label = "bigswap";
    }
  ];

  networking.hostName = "gurl"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with upkgs.ibus-engines; [ typing-booster ];
   };


  # Enable the X11 windowing system.
  services.xserver = {
    enable= true;
    layout = "us";
    xkbVariant = "";
    desktopManager = {
      gnome.enable = true;
    };
    
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        
      };
      autoLogin.enable = false;
    };
  };
  services.tlp.enable = false;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
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

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blue = {
    isNormalUser = true;
    description = "blue linden";
    extraGroups = [ "networkmanager" "wheel" "configmanager" ];
  };
  users.groups.configmanager = {
    name = "configmanager";
  	members = ["blue"];
  	gid = 1337;
  };
  users.defaultUserShell = pkgs.zsh;



  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    upkgs.nodejs_21
    upkgs.nodePackages_latest.pnpm
    upkgs.yarn
    inkscape-updated
    bun-baseline
    hexedit
    comma
    upkgs.deno
    upkgs.adw-gtk3
    asciinema
    nixpkgs-fmt
    unzip
    gnumake
    dig
    git-lfs
    pciutils
    gparted
    steam-run
    maturin
    clang
    python310Full
    python310Packages.pip
    python310Packages.setuptools
    nix-init
    wscribe
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
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
    SuspendState=freeze
  '';
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.tmpfiles.rules = [
    "d /cfg 1774 root configmanager"
  ];

  # home manager config!
  home-manager = {
    useGlobalPkgs = true;
    users = {
      blue = import ./home/blue/home.nix {specialArgs = specialArgs;};
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
  	];
  };
}
