# This function creates a NixOS system based on config.
{ nixpkgs, overlays, inputs }:

name:
{
  system,
  user
}:

let
  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userHMConfig = ../users/${user}/home-manager.nix;
in nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    # Apply overlays.
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }

    machineConfig
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
      };
    }
 
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        inputs = inputs;
      };
    }
  ];
}
