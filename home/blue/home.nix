{specialArgs}: 
let pkgs = specialArgs.s-nixpkgs; upkgs = specialArgs.u-nixpkgs;
in {
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    activitywatch
    gnome.dconf-editor
    gnome.ghex
    gnome.gnome-terminal
    gnome.gitg
    upkgs.firefox
    upkgs.upscayl
    direnv
    thunderbird
    floorp
    gay
    fractal
#    upkgs.libresprite
    gnome3.gnome-tweaks
    gnome.gnome-boxes
    cosmocc
    flyctl
    # textpieces
    qpwgraph
    zint
    fontforge
    upkgs.lapce
    virt-viewer
    impression
    upkgs.beeper
    blender
    htop
    upkgs.minecraft
    fraunces
    lexend
    upkgs.aseprite
#    upkgs.inkscape
    ookla-speedtest
    emulsion-palette
    halftone
    safeeyes
    dell-command-configure
    drawing
    ungoogled-chromium
    upkgs.anytype
    upkgs.vivaldi
    upkgs.bruno
    upkgs.localsend
    upkgs.trayscale
    dynamic-wallpaper
    upkgs.gnome-frog
    gnomeExtensions.blur-my-shell
    gnomeExtensions.burn-my-windows
    gnomeExtensions.appindicator
    gnomeExtensions.tailscale-qs
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
    # gnomeExtensions.paperwm
    gnomeExtensions.compiz-windows-effect
  	(makeDesktopItem {
  	  name = "windows-vm-launch";
  	  desktopName = "Windows 11 Pro";
  	  exec = "${pkgs.stdenv.shell} ${./vms/windows.sh}";
  	  comment = "Windows environment for use with Windows software";
  	  icon = "${papirus-icon-theme}/share/icons/Papirus/128x128/apps/windows95.svg";
  	  terminal = true;
  	})
  ];
  
  
  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.local/share/npm-global/bin"
  ];
  home.sessionVariables = rec {
  	NIXOS_OZONE_WL = 1;
  	XDG_CACHE_HOME  = "$HOME/.cache";
  	XDG_CONFIG_HOME = "$HOME/.config";
  	XDG_DATA_HOME   = "$HOME/.local/share";
  	XDG_STATE_HOME  = "$HOME/.local/state";
  	WSCRIBE_MODELS_DIR = "${XDG_DATA_HOME}/whisper-models";
  };
  programs = {
    nushell = {
      enable = true;
    };
    git = {
      enable = true;
      userEmail = "dev@bluelinden.art";
      userName = "blue linden";
      extraConfig = {
      	init.defaultBranch = "main";
      	safe.directory = "/cfg";
      };
    };
    gh = {
      enable = true;
      package = upkgs.gh;
      settings = {
      	version = 1;
      };
    };
    zsh = {
      enable = true;
      # oh-my-zsh.enable = true;

      
      plugins = [
      	{
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = pkgs.lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
      autocd = true;
      history = {
      	save = 1000;
      	share = true;
      	expireDuplicatesFirst = true;
      };
      
      shellAliases = {
      	"vite" = "bunx vite";
      };
      profileExtra = ''
        if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
    };
  };
  
}

