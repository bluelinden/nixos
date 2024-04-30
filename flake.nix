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
        };
      };
    in
    {
      nixosConfigurations.boo = inputs.s-nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix inputs.lanzaboote.nixosModules.lanzaboote inputs.nix-index-database.nixosModules.nix-index { programs.nix-index-database.comma.enable = true; } ];
        system = "x86_64-linux";
        specialArgs = { inputs = inputs; s-nixpkgs = custom-nixpkgs.stable; u-nixpkgs = custom-nixpkgs.unstable; };
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

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "u-nixpkgs";

    u-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    s-nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    lanzaboote.url = "github:nix-community/lanzaboote";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
  };
}
