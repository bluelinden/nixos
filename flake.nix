{
  outputs = inputs:
    let custom-nixpkgs = {
      unstable = import inputs.u-nixpkgs {system = "x86_64-linux"; config.allowUnfree = true;};
      stable = import inputs.s-nixpkgs {system = "x86_64-linux"; config.allowUnfree = true;};
    };
    in {
      nixosConfigurations.gurl = inputs.s-nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
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
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "u-nixpkgs";
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
    niri-source = {
      url = "github:YaLTeR/niri";
      flake = false;
    };
    
    u-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    s-nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flatpaks.url = "github:GermanBread/declarative-flatpak/dev";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "s-nixpkgs";
    };
  };
}
