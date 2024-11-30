{
  outputs = inputs:
    let
      custom-nixpkgs = {
        unstable = import inputs.u-nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; config.permittedInsecurePackages = [ "electron-25.9.0" "pulsar-1.114.0" "electron-27.3.11" ]; };
        stable = import inputs.s-nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.joypixels.acceptLicense = true;
          config.permittedInsecurePackages = [
            "electron-25.9.0"
            "electron-27.3.11"
          ];
          overlays = [ inputs.niri.overlays.niri inputs.chaotic.overlays.default ];
        };
      };
    in
    {
      nixosConfigurations.boo = inputs.s-nixpkgs.lib.nixosSystem {
        modules = [
          inputs.niri.nixosModules.niri
          inputs.impermanence.nixosModules.impermanence
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.nix-index
          # pre-config settings stuff
          {
            config.programs.niri.enable = true;
            config.programs.niri.package = custom-nixpkgs.stable.niri-unstable;
            config.nix.settings.extra-substituters = [
              "https://cache.lix.systems"
            ];
            config.nix.settings.trusted-public-keys = [
              "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
            ];
          }
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          inputs.nixos-cosmic.nixosModules.default
          ./configuration.nix
          inputs.lix-module.nixosModules.default


        ];
        system = "x86_64-linux";
        specialArgs = { inputs = inputs; s-nixpkgs = custom-nixpkgs.stable; u-nixpkgs = custom-nixpkgs.unstable; v-nixpkgs = custom-nixpkgs.vivaldi; };
      };
    };

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    impermanence.url = "github:nix-community/impermanence";


    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
    cosmic-ext-alternative-startup.url = "github:bluelinden/cosmic-ext-alternative-startup";
    zen-browser.url = "github:FBIGlowie/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "s-nixpkgs";
    stylix.url = "github:danth/stylix/cf8b6e2d4e8aca8ef14b839a906ab5eb98b08561";
    # jovian = {
    #   url = "github:Jovian-Experiments/Jovian-NixOS";
    #   inputs.nixpkgs.follows = "s-nixpkgs";
    # };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "u-nixpkgs";

    u-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    s-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
  };
}
