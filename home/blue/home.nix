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
    thunderbird
    gay
    ulauncher
    fractal
#    upkgs.libresprite
    gnome3.gnome-tweaks
    cosmocc
    vscode-fhs
    upkgs.beeper
    htop
    fraunces
    lexend
    upkgs.aseprite
#    upkgs.inkscape
    ookla-speedtest
    safeeyes
    ungoogled-chromium
    upkgs.vivaldi
    upkgs.bruno
    upkgs.localsend
    dynamic-wallpaper
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
    # gnomeExtensions.paperwm
    gnomeExtensions.compiz-windows-effect
  ];
  home.sessionPath = [
    "$HOME/.bun/bin"
  ];
  home.sessionVariables = rec {
  	NIXOS_OZONE_WL = 1;
  	XDG_CACHE_HOME  = "$HOME/.cache";
  	XDG_CONFIG_HOME = "$HOME/.config";
  	XDG_DATA_HOME   = "$HOME/.local/share";
  	XDG_STATE_HOME  = "$HOME/.local/state";
  	WSCRIBE_MODELS_DIR = "${XDG_DATA_HOME}/whisper-models";
  };
  systemd = {
  	user = {
  	  services = {
  	  	ulauncher = {
  	  	  Unit = {
  	  	  	Description = "Starts ULauncher. Does nothing else.";  	  	  	
  	  	  };
  	  	  Install = {
  	  	  	WantedBy = ["gnome-session.target"];
  	  	  };
  	  	  Service = {
  	  	  	ExecStart = "${pkgs.ulauncher}/bin/ulauncher";
  	  	  };
  	  	};
  	  };
  	};
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
    };
    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
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
      '';
    };
  };
  
}

