{ specialArgs }:
let
  pkgs = specialArgs.s-nixpkgs;
  upkgs = specialArgs.u-nixpkgs;
  floorp-updated-bin = upkgs.callPackage (import ../../packages/floorp/default.nix) { };
  floorp-updated-wrapper = (import ../../packages/floorp/wrapper.nix);
  pulsar = upkgs.callPackage (import ../../packages/pulsar/default.nix) { };
  code-configuration = ((import ./code.nix) { inherit upkgs; inherit pkgs; extensions = specialArgs.inputs.nix-vscode-extensions.extensions; });
in
{

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    activitywatch
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    gnome.ghex
    gnome.gnome-terminal
    gnome.gitg
    firefox-bin
    # upkgs.upscayl
    direnv
    soundux
    thunderbird
    tuba
    (pkgs.wrapFirefox floorp-updated-bin { })
    gay
    fractal
    #    upkgs.libresprite
    gnome3.gnome-tweaks
    gnome.gnome-boxes
    cosmocc
    flyctl
    cloc
    # textpieces
    apostrophe
    qpwgraph
    helvum
    zint
    handbrake
    fontforge
    upkgs.lapce
    rustup
    binwalk
    # for dictation!
    lame
    zoxide
    # pulsar
    nnn
    ffmpeg
    openai-whisper-cpp
    sox
    virt-viewer
    impression
    upkgs.beeper
    easyeffects
    metasploit
    zap
    armitage
    postgresql
    ddev
    wp-cli
    php81Packages.composer
    vagrant
    upkgs.kanidm
    blender
    lmms
    upkgs.warp-terminal
    htop
    upkgs.minecraft
    upkgs.prismlauncher
    gnome.iagno
    fraunces
    lexend
    upkgs.pgmodeler
    sqlfluff
    upkgs.aseprite
    # upkgs.inkscape
    ookla-speedtest
    emulsion-palette
    halftone
    obsidian
    sirikali
    safeeyes
    dell-command-configure
    drawing
    ungoogled-chromium
    upkgs.anytype
    upkgs.vivaldi
    upkgs.vivaldi-ffmpeg-codecs
    upkgs.bruno
    upkgs.localsend
    upkgs.trayscale
    upkgs.zola
    dynamic-wallpaper
    upkgs.gnome-frog
    authenticator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.burn-my-windows
    gnomeExtensions.appindicator
    gnomeExtensions.tailscale-qs
    gnomeExtensions.caffeine
    gnomeExtensions.just-perfection
    gnomeExtensions.easyeffects-preset-selector
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
    (writeShellScriptBin "npb" ''
      	  if [ "$#" -ne 2 ]; then
      	    echo "quickie Nix Package Build script by blue linden"
      	    echo "Usage: npb [method] [filePath]"
      	    exit 1
      	  fi
      	  arg1=$1
      	  arg2=$2
      	  nix-build -E "with import <nixpkgs> {}; $arg1 $arg2 {}"
      	'')
  ];


  home.sessionPath = [
    "$HOME/.cache/.bun/bin"
    "$HOME/.local/share/npm-global/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];
  home.shellAliases = {
    # "docker-compose" = "podman-compose";
    "z" = "__zoxide_z";
    "zi" = "__zoxide_zi";
  };
  home.sessionVariables = rec {
    NIXOS_OZONE_WL = 1;
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
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

    bash = {
      enable = true;
      bashrcExtra = ''
        printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash" }}\x9c'
      '';
    };

    vscode = code-configuration;

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
        eval "$(zoxide init zsh --no-cmd)"
      '';
    };
  };


}
