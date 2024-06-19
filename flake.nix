{
  outputs = inputs:
    let
      custom-nixpkgs = rec {
        unstable = import inputs.u-nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; config.permittedInsecurePackages = [ "electron-25.9.0" "pulsar-1.114.0" ]; };
        stable = import inputs.s-nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.joypixels.acceptLicense = true;
          config.permittedInsecurePackages = [
            "electron-25.9.0"
          ];
          overlays = [ inputs.niri.overlays.niri ];
        };
      };
    in
    {
      nixosConfigurations.boo = inputs.s-nixpkgs.lib.nixosSystem {
        modules = [
          inputs.niri.nixosModules.niri
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.nix-index
          inputs.lix-module.nixosModules.default
          # pre-config settings stuff
          {
            config.programs.niri.enable = true;
            config.nix.settings.extra-substituters = [
              "https://cache.lix.systems"
            ];
            config.nix.settings.trusted-public-keys = [
              "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
            ];
          }
          ./configuration.nix
        ];
        system = "x86_64-linux";
        specialArgs = { inputs = inputs; s-nixpkgs = custom-nixpkgs.stable; u-nixpkgs = custom-nixpkgs.unstable; v-nixpkgs = custom-nixpkgs.vivaldi; };
      };
    };

  inputs = {
    nix-software-center = {
      type = "github";
      owner = "vlinkz";
      repo = "nix-software-center";
    };
    nixos-conf-editor = {
      type = "github";
      owner = "vlinkz";
      repo = "nixos-conf-editor";
    };
    nix-alien = {
      type = "github";
      owner = "thiagokokada";
      repo = "nix-alien";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    stylix.url = "github:danth/stylix";
    # jovian = {
    #   url = "github:Jovian-Experiments/Jovian-NixOS";
    #   inputs.nixpkgs.follows = "s-nixpkgs";
    # };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "u-nixpkgs";

    u-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    s-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    v-nixpkgs.url = "github:NixOS/nixpkgs/a1f51a5fee39a3e90c1e13b881ab82d4987d7fc6";
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
  };
}
