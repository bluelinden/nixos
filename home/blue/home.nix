{specialArgs}: 
let pkgs = specialArgs.s-nixpkgs; upkgs = specialArgs.u-nixpkgs;
in {
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    activitywatch
    gnome.dconf-editor
    firefox
    thunderbird
    ulauncher
    gnome3.gnome-tweaks
    upkgs.vscode.fhs
    htop
    upkgs.bruno
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
    gnomeExtensions.paperwm    
  ];
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

