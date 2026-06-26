{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware.nix
    ./modules/system.nix
    ./modules/desktop.nix
    ./modules/security.nix
    ./modules/apps.nix
    ./users/user.nix
  ];
 
  system.stateVersion = "26.05";
}
