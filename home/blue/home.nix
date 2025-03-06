{ specialArgs, config, lib, ... }:
let
  pkgs = specialArgs.s-nixpkgs;
  upkgs = specialArgs.u-nixpkgs;
  code-configuration = ((import ./code.nix) {
    inherit upkgs; inherit pkgs; extensions = specialArgs.inputs.nix-vscode-extensions.extensions;
  });

in
{

  imports = [
    ./zed.nix
  ];

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    xwayland-satellite-unstable
    xwayland-run
    gtklock
    # activitywatch
    dconf-editor
    gnome-sound-recorder
    ghex
    gnome-terminal
    gitg

    vcv-rack

    redact
    
    # bottles
    firefox-bin
    upkgs.zed-editor
    thunderbird-latest
    # upkgs.upscayl
    direnv
    # gimp-with-plugins

    # qFlipper

    # thunderbird
    tuba
    slack
    gay
    fractal
    #    upkgs.libresprite
    flyctl
    cloc
    # textpieces
    apostrophe
    google-cursor
    qpwgraph
    helvum
    zint
    handbrake
    fontforge
    # rustup
    qmk
    vial
    # binwalk
    lame
    zoxide
    # pulsar
    kooha
    nnn
    zellij
    ffmpeg
    openai-whisper-cpp
    sox
    virt-viewer
    impression
    overskride
    # networkmanagerapplet
    cosmic-applets
    easyeffects
    metasploit
    armitage
    postgresql
    ddev
    devenv
    wp-cli
    php81Packages.composer
    upkgs.kanidm
    libreoffice
    # upkgs.blender
    olive-editor
    # looking-glass-client
    upkgs.warp-terminal

    keypunch
    delfin

    pamixer
    # upkgs.minecraft
    upkgs.prismlauncher
    iagno
    fraunces
    lexend
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    upkgs.pgmodeler
    sqlfluff
    # upkgs.aseprite
    steamcmd
    openloco
    openttd

    checkra1n

    usbguard-notifier

    upkgs.aseprite

    # cosmic-ext-applet-clipboard-manager
    # cosmic-ext-applet-emoji-selector
    # cosmic-ext-applet-external-monitor-brightness

    # upkgs.inkscape
    #
    penpot-desktop

    (colloid-gtk-theme.override {sizeVariants = ["compact"];})
    
    ookla-speedtest
    emulsion-palette
    halftone
    imhex
    sniffnet
    safeeyes
    # dell-command-configure
    drawing
    nil
    nixfmt-classic
    ungoogled-chromium
    # networkmanagerapplet
    (vivaldi.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })
    vivaldi-ffmpeg-codecs
    upkgs.bruno
    upkgs.localsend
    upkgs.trayscale
    upkgs.zola
    dynamic-wallpaper
    upkgs.gnome-frog
    authenticator
    logseq
    specialArgs.inputs.zen-browser.packages."x86_64-linux".specific
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
    (writeShellScriptBin "ewwdev" ''
      pidof eww && pkill eww
      ACT=$1
      shift 1
      eww $ACT --config /cfg/home/blue/eww/ "$@"

    '')

    (writeShellScriptBin "run" ''
      niri msg action spawn -- "$@"
    '')
  ];


  home.sessionPath = [
    "$HOME/.cache/.bun/bin"
    "$HOME/.local/share/npm-global/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];
  home.sessionVariables = rec {
    WSCRIBE_MODELS_DIR = "${XDG_DATA_HOME}/whisper-models";
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    NIXOS_OZONE_WL = 1;
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PKG_CONFIG_PATH = ''${pkgs.systemd.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.dbus.dev}/lib/pkgconfig'';
  };

  stylix.targets = {
    vscode.enable = false;
    tofi.enable = false;
    mako.enable = false;
    xresources.enable = false;

  };

  programs = {
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

    # vscode = code-configuration;

    # stylix.targets.vscode.enable = false;


    zsh = {
      enable = true;
      # oh-my-zsh.enable = true;

      autocd = true;
      history = {
        save = 1000;
        share = true;
        expireDuplicatesFirst = true;
      };

      profileExtra = ''
        if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        eval "$(zoxide init zsh --no-cmd)"
      '';
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    nushell = {
      enable = true;
      configFile.text = ''
        $env.config.show_banner = false
      '';
      extraEnv = ''
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/blue/.cache/.bun/bin |
          prepend /home/blue/.local/bin |
          prepend /home/blue/.cargo/bin
        )
        $env.PKG_CONFIG_PATH = "${pkgs.systemd.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.dbus.dev}/lib/pkgconfig"
      '';
    };

    zellij = {
      enable = true;
      settings = {
        default_shell = "${pkgs.nushell}/bin/nu";
        pane_frames = false;
        simplified_ui = true;
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash" }}\x9c'
      '';

      initExtra = "
        if [[ ! $(ps T --no-header --format=comm | grep \"^nu$\") && -z $BASH_EXECUTION_STRING ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
            exec \"${lib.getExe pkgs.nushell}\" \"$LOGIN_OPTION\"
        fi
      ";
    };

    carapace.enable = true;

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };

    alacritty = {
      enable = true;
      settings = {
        terminal.shell = {
          program = "${pkgs.zellij}/bin/zellij";
        };
      };
    };

    lazygit = {
      enable = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        editor = {
          shell = [ "nu" "-c" ];
          cursor-shape = {
            normal = "block";
            insert = "underline";
            select = "bar";
          };
          indent-guides = {
            render = true;
            character = "╎";
          };
          soft-wrap = {
            enable = true;
          };
          bufferline = "multiple";
          color-modes = true;
        };
        keys = {
          normal = {
            C-S-z = "redo";
            C-q = ":q";
            C-s = ":w";
            C-z = "undo";
          };
          insert = {
            C-S-z = "redo";
            C-q = ":q";
            C-s = ":w";
            C-z = "undo";
          };
        };
      };
    };

    niri = {
      # enable = true;
      # package = pkgs.niri-unstable;
      settings = {
        input = {
          keyboard = {
            xkb = {
              model = "latitude";
              layout = "us";
              options = "caps:hyper,compose:ralt";
            };
          };

          mouse = {
            accel-profile = "adaptive";
          };
          touchpad = {
            accel-profile = "adaptive";
            click-method = "clickfinger";
            tap-button-map = "left-right-middle";
            scroll-factor = 0.6;
          };
          trackpoint = {
            accel-profile = "flat";
          };
        };
        layout = {
          preset-column-widths = [
            { proportion = 1. / 3.; }
            { proportion = 1. / 2.; }
            { proportion = 2. / 3.; }
            { proportion = 1. / 1.; }
          ];
          gaps = 8;
          focus-ring = {
            width = 6;
            active = {
              gradient = {
                from = "#ead2d8";
                to = "#d5a5b6";
                angle = 340;
              };

            };
            inactive = {
              gradient = {
                from = "#5c1a34";
                to = "#4b1128";
                angle = 340;
              };
            };
          };
        };
        animations = {
          horizontal-view-movement = {
            spring = {
              damping-ratio = 0.700000;
              epsilon = 0.000100;
              stiffness = 600;
            };
          };
          window-movement = {
            spring = {
              damping-ratio = 0.700000;
              epsilon = 0.000100;
              stiffness = 600;
            };
          };
          window-resize = {
            spring = {
              damping-ratio = 0.700000;
              epsilon = 0.000100;
              stiffness = 600;
            };
          };
          window-open = {
            spring = {
              damping-ratio = 0.700000;
              epsilon = 0.000100;
              stiffness = 600;
            };
          };
        };
        binds = with config.lib.niri.actions; {
          # basics
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+T".action = spawn "${pkgs.alacritty}/bin/alacritty";
          "Mod+Space".action = spawn "cosmic-launcher";
          "Mod+A".action = spawn "cosmic-app-library";
          "Mod+Z".action = spawn "zeditor";
          "Mod+B".action = spawn "zen";
          "Mod+Alt+Space".action = spawn "${pkgs.dash}/bin/dash" "-c" "$(${pkgs.tofi}/bin/tofi-run)";
          "Super+L".action = spawn "${pkgs.systemd}/bin/loginctl" "lock-session";


          # pipewire audio stuff
          "XF86AudioRaiseVolume" = { action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" ]; allow-when-locked = true; };
          "XF86AudioLowerVolume" = { action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" ]; allow-when-locked = true; };
          "XF86AudioMute" = { action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; allow-when-locked = true; };
          "XF86AudioMicMute" = { action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ]; allow-when-locked = true; };
          "XF86MonBrightnessDown" = { action.spawn = [ "brightnessctl" "s" "5%-" ]; allow-when-locked = true; };
          "XF86MonBrightnessUp" = { action.spawn = [ "brightnessctl" "s" "+5%" ]; allow-when-locked = true; };
          

          # quit
          "Mod+Q".action = close-window;

          # traversal
          "Mod+Left".action = focus-column-left;
          "Mod+Down".action = focus-window-down;
          "Mod+Up".action = focus-window-up;
          "Mod+Right".action = focus-column-right;
          # TODO: vim bindings for traversal

          # movement
          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Down".action = move-window-down;
          "Mod+Ctrl+Up".action = move-window-up;
          "Mod+Ctrl+Right".action = move-column-right;
          # TODO: vim bindings for movement

          "Mod+Home".action = focus-column-first;
          "Mod+End".action = focus-column-last;
          "Mod+Ctrl+Home".action = move-column-to-first;
          "Mod+Ctrl+End".action = move-column-to-last;

          "Mod+Shift+Left".action = focus-monitor-left;
          "Mod+Shift+Down".action = focus-monitor-down;
          "Mod+Shift+Up".action = focus-monitor-up;
          "Mod+Shift+Right".action = focus-monitor-right;
          # TODO: vim bindings for monitor traversal

          "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
          # TODO: vim bindings for monitor col movement

          "Mod+Page_Down".action = focus-workspace-down;
          "Mod+Page_Up".action = focus-workspace-up;
          "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
          "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;

          "Mod+Shift+Page_Down".action = move-workspace-down;
          "Mod+Shift+Page_Up".action = move-workspace-up;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = reset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Plus".action = set-column-width "+10%";

          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Plus".action = set-window-height "+10%";

          "Print".action = screenshot;
          "Ctrl+Print".action = screenshot-screen;
          "Alt+Print".action = screenshot-window;

          "Mod+Shift+Q".action = quit;

          "Mod+Shift+P".action = power-off-monitors;

        };
        hotkey-overlay.skip-at-startup = true;
        environment = {
          DISPLAY = ":13";
        };
        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 12.;
                bottom-right = 12.;
              top-left = 12.;
                top-right = 12.;
            };
            clip-to-geometry = true;
          }
        ];
        spawn-at-startup = [
          {
            command = [ "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite" ":13" ];
          }
          {
            command = [ "${specialArgs.inputs.cosmic-ext-alternative-startup.packages.x86_64-linux.default}/bin/cosmic-ext-alternative-startup" ];
          }
          {
            command = [ "${pkgs.niri-unstable}/bin/niri" "msg" "output" "eDP-1" "scale" "1" ];
          }
          {
            command = [ "${pkgs.dbus}/bin/dbus-update-activation-environment" "DISPLAY" ];
          }
          {
            command = [ "${pkgs.systemd}/bin/systemctl" "--user" "import-environment" ];
          }
        ];
        prefer-no-csd = true;
      };




    };

    

    #    hyprlock = {
    #      enable = true;
    #      settings = {
    #        general = {
    #          disable_loading_bar = true;
    #          hide_cursor = true;
    #          grace = 300;
    #          ignore_empty_input = true;
    #        };
    #
    #        background = [{
    #          monitor = "";
    #          color = "rgba(0, 0, 0, 1)";
    #        }];
    #
    #        input-field = [{
    #          size = "800, 50";
    #          outline_thickness = 0;
    #          dots_size = 0.33;
    #          outer_color = "rgb(0, 0, 0)";
    #          inner_color = "rgb(0, 0, 0)";
    #          font_color = "rgb(200, 200, 200)";
    #          placeholder_text = "locked.";
    #          hide_input = false;
    #          dots_center = true;
    #
    #          check_color = "rgb(10, 10, 10)";
    #          fail_color = "rgb(50, 10, 10)";
    #          fail_transition = 50;
    #
    #
    #          position = "0, 25";
    #          halign = "center";
    #          valign = "bottom";
    #
    #        }];
    #
    #
    #
    #      };
    #    };

    # wpaperd = {
    #   enable = true;
    # };



    tofi = {
      enable = true;
      settings = {
        font = "${pkgs.inter}/share/fonts/opentype/Inter-Bold.otf";
        font-size = 32;
        width = "100%";
        height = "100%";
        border-width = 0;
        outline-width = 0;
        padding-left = "35%";
        padding-top = "35%";
        result-spacing = 25;
        num-results = 5;
        background-color = "#000";
        monitor = "";
      };
    };

    eww = {
      enable = true;
      configDir = ./eww;
    };

    thefuck.enable = true;
    thefuck.enableNushellIntegration = true;


  };
  services = {
    gnome-keyring.enable = true;
    # mako = {
    #   enable = true;
    #   # backgroundColor = "#000";
    #   # borderColor = "#000";
    #   # borderRadius = 20;
    #   # borderSize = 0;
    #   # font = "Inter 12";
    #   iconPath = "${pkgs.papirus-icon-theme}/share/icons/papirus";
    # };
    hypridle = {
      enable = true;
      settings = {
        general = {
          #          lock_cmd = "pidof hyprlock || (hyprlock --immediate && pkill hyprlock)";
          #          unlock_cmd = "pkill -USR1 hyprlock";
          before_sleep_cmd = "loginctl lock-session";

        };
        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl - s set 10%";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "niri ctl action power-off-monitors";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };

    };
    # network-manager-applet.enable = true;

    # blueman-applet.enable = true;

    kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      profiles = {
        laptop-only = {
          name = "laptop-only";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1080@60.012";
              scale = 1.0;
            }
          ];
        };
        samsung-monitor = {
          name = "samsung-monitor";
          outputs = [
            {
              criteria = "BOE 0x072F Unknown";
              mode = "1920x1080@60.012";
              scale = 1.0;
              position = "0,150";
            }
            {
              criteria = "HDMI-A-1";
              mode = "1680x1050@59.883";
              scale = 1.0;
              position = "1920,0";
            }
          ];
        };
      };
    };

    activitywatch = {
      enable = true;
      package = pkgs.aw-server-rust;
      watchers = {
        awatcher = {
          package = upkgs.awatcher;
        };
      };
    };

    gammastep = {
      provider = "geoclue2";
      enable = true;
      settings = {
        general.adjustment-method = "wayland";
      };
      tray = true;
    };

  };

  systemd.user.services.gammastep.unitConfig.Environment = "WAYLAND_DISPLAY=wayland-1";

  systemd.user.services.hypridle.Unit.After = lib.mkForce
    [ "graphical-session.target" ];


  # systemd.user.services.usbguard-notifier = {
  #   script = "${pkgs.usbguard-notifier}/bin/usbguard-notifier";
  #   after = "graphical-session.target";
  # };


  dconf.settings."org/blueman/general" = {
    plugin-list = [ "!ConnectionNotifier" ];
  };

  gtk.iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
  };

  xsession.preferStatusNotifierItems = true;
}
