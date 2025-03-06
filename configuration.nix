# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, specialArgs, ... }:
let
  pkgs = specialArgs.s-nixpkgs;
  upkgs = specialArgs.u-nixpkgs;
  webusb-udev = upkgs.callPackage ./packages/webusb-udev/default.nix { };
  fenix = specialArgs.inputs.fenix;
  niri = specialArgs.inputs.niri;
  chaotic = specialArgs.inputs.chaotic;
  stylix = specialArgs.inputs.stylix;
  nix-ld-so = pkgs.runCommand "ld.so" { } ''
    ln -s "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')" $out
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      specialArgs.inputs.home-manager.nixosModules.home-manager
      specialArgs.inputs.flatpaks.nixosModules.declarative-flatpak
      specialArgs.inputs.chaotic.nixosModules.default
      stylix.nixosModules.stylix
      ./system/networking/dns.nix
      ./system/networking/tailscale.nix
      ./system/networking/base.nix
      ./system/languages.nix
      ./system/boo.impermanence.nix
      ./system/utils/ydotool.nix
      ./system/boo.backups.nix
      ./system/cosmic-on-niri.nix
      ./system/boo.usb.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;



  # Bootloader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/state/etc/secureboot";
    };
    # crashDump.enable = true;
    # initrd.verbose = false;
    # consoleLogLevel = 0;
    kernelParams = [ "threadirqs" "preempt=full" "intel_pstate=passive" ];
    initrd.systemd.enable = true;
    initrd.systemd.emergencyAccess = false;
    initrd.kernelModules = [ "tpm-tis" "i915" ];

    # initrd.systemd.emergencyAccess = (import ./emergency-access-password.nix).pwd;
    kernelPackages = upkgs.linuxPackages_xanmod_latest;
    # extraModulePackages = with config.boot.kernelPackages; [ digimend ];
    loader.systemd-boot.graceful = true;
    loader.timeout = 0;
    loader.systemd-boot.editor = false;
    loader.grub.memtest86.enable = false;
    # loader.grub.device = "/dev/sda";
    # loader.grub.efiSupport = true;
    # loader.grub.fontSize = 16;

    loader.grub.enable = false;
    # loader.grub.font = /home/blue/.local/share/fonts/Lexend-VariableFont_wght.ttf;
    # loader.grub.backgroundColor = "#4b1128";
    plymouth.enable = true;
    loader.systemd-boot.configurationLimit = 30;
    loader.efi.canTouchEfiVariables = true;
    kernel.sysctl."kernel.sysrq" = 96;
    bootspec.enable = true;

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # services.ddccontrol.enable = true;
  hardware.i2c.enable = true;
  hardware.xpadneo.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.xone.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.flipperzero.enable = true;

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
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager = {
    cosmic.enable = true;
  };
  # these just make it way easier to use my computer lol, even though i won't have GNOME anymore.
  services.gnome.core-utilities.enable = true;

  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.dleyna-renderer.enable = true;
  services.dleyna-server.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.at-spi2-core.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.hardware.bolt.enable = true;
  services.cpupower-gui.enable = true;
  # TODO: Enable once #177946 is resolved
  # services.packagekit.enable = mkDefault true;
  services.udisks2.enable = true;
  services.upower.enable = config.powerManagement.enable;

  services.dbus = {
    implementation = "broker";
    apparmor = "enabled";
  };

  xdg.mime.enable = true;
  xdg.icons.enable = true;

  xdg.portal.enable = true;

  services.xserver.updateDbusEnvironment = true;

  programs.wireshark.enable = true;

  # gnome has a custom alert theme but it still
  # inherits from the freedesktop theme.

  # Needed for themes and backgrounds
  environment.pathsToLink = [
    "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
  ];


  # services.tlp.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };



  # services.usbmuxd = {
    # enable = true;
  #   # package = pkgs.usbmuxd2;
  # };

  services.fwupd.enable = true;

  services.udev.extraHwdb = ''
    EVDEV_ABS_00=::24
    EVDEV_ABS_01=::23
    EVDEV_ABS_35=::24
    EVDEV_ABS_36=::23
  '';

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/intel_backlight/brightness"
  '';

  programs.light.enable = true;
  services.blueman.enable = true;
  hardware.brillo.enable = true;
  
  services.system76-scheduler.enable = true;
  hardware.system76.power-daemon.enable = false;
  

  # services.gnome.gnome-browser-connector.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    browsing = true;
    # drivers = [
    #   pkgs.canon-cups-ufr2
    # ];
  };



  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.graphics = {
    # driSupport32Bit = false;
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  security.rtkit.enable = true;
  security.sudo-rs = {
    enable = true;
  };
  security.pam.services.login.oathAuth = true;
  security.pam.services.cosmic-greeter.oathAuth = false;
  security.pam.oath = {
    enable = true;
    window = 5;
    usersFile = "/etc/oath/users.oath";
    digits = 6;
  };
  security.apparmor.enable = true;
  security.apparmor.policies.dummy.profile = ''
    /dummy {
    }
  '';
  networking.firewall.extraCommands = ''
    iptables -t nat -A OUTPUT -d 240.0.0.53 -j DNAT --to-destination 127.0.0.1
  '';


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
    wireplumber.extraConfig = {
      "allow-midi" = {"node.features.audio.control-port" = true;};
    };
  };

  programs.dconf.enable = true;
  services.ydotool.enable = true;
  hardware.uinput.enable = true;
  # programs.kdeconnect.enable = true;
  # programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  programs.command-not-found.enable = false;
  programs.nix-ld.enable = true;
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    # virtualisation.docker.enable = true;
    # virtualisation.docker.rootless.enable = true;
    # virtualisation.docker.rootless.daemon.settings = {
    # dns = ["127.0.0.1"];
    # };
    # virtualisation.docker.rootless.setSocketVariable = true;
    libvirtd.qemu.swtpm.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
      extraPackages = [ pkgs.zfs ];
    };
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          dns = [ "240.0.0.53" ];
        };
      };
    };
    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "$XDG_DATA_HOME/containers";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
    oci-containers.backend = "docker";
    waydroid.enable = true;
  };


  # jovian steam creates a gamescope session
  # jovian.steam.enable = true;
  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  # environment.extraInit = ''
  # if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
  # export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  # fi
  # '';



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blue = {
    isNormalUser = true;
    description = "blue linden";
    extraGroups = [ "networkmanager" "wheel" "configmanager" "plugdev" "i2c" "ddc" "libvirtd" "dialout" "uinput" "input" "wireshark" "usbguard" ];
    shell = pkgs.bash;
    hashedPasswordFile = "/state/etc/blpw";
  };
  users.groups.configmanager = {
    name = "configmanager";
    members = [ "blue" ];
    gid = 1337;
  };

  systemd.user.services.usbguard-notifier = {
    script = "${pkgs.usbguard-notifier}/bin/usbguard-notifier -w";
    after = [ "graphical-session.target" ];
    unitConfig = {
      ConditionGroup = "usbguard";
    };
  };



  users.groups.ddc = { };
  users.groups.usbguard = { };

  users.mutableUsers = false;

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
    upkgs.morewaita-icon-theme
    gum
    distrobox
    sbctl
    upkgs.nodejs_22
    upkgs.nodePackages_latest.pnpm
    upkgs.yarn
    upkgs.bun
    colmena
    mkcert
    hexedit

    lynis

    screen
    brightnessctl
    # localwp
    comma
    libinput
    pipx
    upkgs.deno
    tpm2-tss
    upkgs.ulauncher
    upkgs.adw-gtk3
    opendrop
    owl
    asciinema
    d-spy
    php81
    php81Packages.composer
    stress
    s-tui
    nixd
    nixpkgs-fmt
    gnome-network-displays
    python3
    linuxHeaders
    tree
    firmware-updater
    dnsmasq
    neofetch
    fastfetch

    talosctl

    sound-theme-freedesktop

    godot_4

    git-crypt
    
    qemu
    unzip
    gnumake
    inkscape
    pkg-config
    cairo
    dig
    htop
    git-lfs
    dua
    # docker-compose
    podman-compose
    # upkgs.vscode.fhs
    webusb-udev
    pciutils
    usbutils
    gparted
    steam-run
    maturin
    slirp4netns
    libimobiledevice
    idevicerestore
    ifuse
    clang
    curlFull
    ddcui
    ddcutil
    ddccontrol-db
    mosh
    openssl
    openssl.dev
    perl

    cachix



    # rust toolchain
    (fenix.packages.x86_64-linux.complete.toolchain)
    rust-analyzer

    # rev-eng stuff
    e2fsprogs
    # jefferson
    pigz
    mtdutils
    _7zz
    python311Packages.bincopy
    # binwalk
    sasquatch
    zip
    unar
    # ghidra
    python311Packages.python-lzo
    arp-scan
    nmap
    rustscan
    trippy
    traceroute
    sniffnet
    nmapsi4
    wirelesstools
    wireshark
    termshark
    tcpdump
    lynis
    gobuster
    openvas-scanner
    upkgs.binsider

    protobuf
    llvmPackages.libclang
    llvm
    llvmPackages.bintools
    llvmPackages.clangUseLLVM
    rust-bindgen
    upkgs.devenv
    wl-clipboard
    input-fonts

    webkitgtk.dev
    librsvg.dev
    glib.dev
    glib
    bzip2
    bzip2.dev

    powertop

    nix-tree

    specialArgs.inputs.nixos-cosmic.packages.x86_64-linux.cosmic-session
    specialArgs.inputs.cosmic-ext-alternative-startup.packages.x86_64-linux.default

    cpupower-gui
    
    # python310Full
    # python310Packages.pip
    # python310Packages.setuptools
    nix-init
    # upkgs.mission-center
    # wscribe
  ];
  environment.binsh = "${pkgs.dash}/bin/dash";

  programs.direnv.enable = true;

  environment.sessionVariables = {
    BINDGEN_EXTRA_CLANG_ARGS = ((builtins.map (a: ''-I"${a}/include"'') [
      # add dev libraries here (e.g. pkgs.libvmi.dev)
      pkgs.glibc.dev
    ])
    # Includes with special directory paths
    ++ [
      ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
      ''-I"${pkgs.glib.dev}/include/glib-2.0"''
      ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
    ]);
  };

  # environment.gnome.excludePackages = with pkgs.gnome; [
    # gnome-software
  # ];

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
  nix.settings.trusted-users = [ "root" "blue" ];
  nix.extraOptions = ''
    min-free = ${toString (5 * 1024 * 1024 * 1024)}
    max-free = ${toString (15 * 1024 * 1024 * 1024)}
  '';

  # services.beesd.filesystems.boocrypt = {
  #   spec = "/dev/mapper/boocrypt";
  #   hashTableSizeMB = 2048;
  #   workDir = "/var/lib/beesd";
  # };

  appstream.enable = true;
  programs.zsh.zsh-autoenv.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.thefuck.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  zramSwap.enable = true;
  powerManagement.cpufreq.min = 400000;
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.powertop.enable = true;
  location.provider = "geoclue2";
  services.geoclue2.geoProviderUrl = "https://beacondb.net/v1/geolocate";
  # systemd.sleep.extraConfig = ''
  #   HibernateMode=shutdown
  #   SuspendState=freeze
  # '';
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 blue kvm -"
  ];

  programs.nh = {
    enable = true;
    flake = "/cfg";
    clean = {
      enable = true;
    };
  };



  systemd.user.services.docker-port-forwarder = {
    description = "Docker Port Forwarder Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = (pkgs.writeShellScript "dpf.sh" (builtins.readFile ./docker-port-forwarder.sh)) + " 53:53";
      Restart = "always";
    };
  };


  # home manager config!
  home-manager = {
    useGlobalPkgs = true;
    users = {
      blue = import ./home/blue/home.nix;
    };
    extraSpecialArgs = specialArgs;
    useUserPackages = true;
  };

  services.flatpak = {
    enable = true;
    enable-debug = true;
    target-dir = "/var/lib/flatpak";
    remotes = {
      "gnome-nightly" = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/net.mkiol.SpeechNote/x86_64/stable"
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/org.gnome.Decibels/x86_64/stable"
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:app/re.sonny.Workbench/x86_64/stable"
      "flathub:app/com.github.iwalton3.jellyfin-media-player/x86_64/stable"
      "flathub:runtime/org.freedesktop.Sdk.Extension.rust-stable/x86_64/24.08"
      "flathub:runtime/org.freedesktop.Sdk.Extension.llvm18/x86_64/24.08"
      "flathub:runtime/org.freedesktop.Sdk.Extension.node20/x86_64/24.08"
      "flathub:runtime/org.freedesktop.Sdk.Extension.typescript/x86_64/24.08"
    ];
  };
  systemd.services.manage-system-flatpaks.serviceConfig.Nice = 20;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = [
      pkgs.joypixels
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.zed-mono
      pkgs.input-fonts
      
    ];
    fontconfig.defaultFonts.emoji = [
      "JoyPixels"
    ];
  };

  stylix = {
    enable = true;
    image = ./photos/HIYA.png;
    base16Scheme = ./colors/monokai.yml;
    fonts = {
      serif = {
        package = pkgs.fraunces;
        name = "Fraunces";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.joypixels;
        name = "JoyPixels";
      };
    };
    cursor = {
      package = pkgs.google-cursor;
      name = "GoogleDot-Black";
      size = 24;
    };
    targets = {
      plymouth = {
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake-white.png";
        logoAnimated = false;
      };
      chromium.enable = false;
    };
  };

  # CHAOTIC NYX TROUBLE ZONE!!
  chaotic.nyx.overlay.enable = true;
  chaotic.nyx.cache.enable = true;
  # boot.kernelPackages = pkgs.linuxPackages_testing;
  services.scx.enable = true;
  services.scx.scheduler = "scx_lavd";


}
