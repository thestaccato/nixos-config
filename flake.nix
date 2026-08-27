{
  description = "NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    # Other packages
    jujutsu.url = "github:martinvonz/jj";
    zig.url = "github:mitchellh/zig-overlay"; 
  };

  outputs = { nixpkgs, ... }@inputs: let
    overlays = [
      inputs.jujutsu.overlays.default
      inputs.zig.overlays.default
      inputs.nur.overlays.default
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    # NixOS host.
    nixosConfigurations.host = mkSystem "host" {
      system = "x86_64-linux";
      user   = "amrahs";
    };

    # NixOS VM.
    nixosConfigurations.vm = mkSystem "vm" {
      system = "x86_64-linux";
      user   = "amrahs";
    };
  };
}
