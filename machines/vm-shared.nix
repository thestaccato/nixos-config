# Configuration shared by both host and VM.
{ config, pkgs, lib, ... }: {
  imports = [
    #../modules/plasma.nix
    ../modules/env.nix
    ../modules/packages.nix
    ../modules/fonts.nix
    ../modules/packages.nix
    ../modules/settings.nix
    ../modules/locale.nix
    ../modules/networking.nix
    ../modules/services.nix
    ../modules/user.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "26.05";
}
