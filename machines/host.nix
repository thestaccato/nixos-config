# NixOS host configuration.
{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware/host.nix
    ./vm-shared.nix
    ../modules/host/audio.nix
    ../modules/host/bluetooth.nix
    ../modules/host/graphics.nix
    #../modules/host/kubernetes.nix
    ../modules/host/services-host.nix
    ../modules/host/virtualization.nix
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelModules = [ "kvm" "kvm_amd" ];

  networking.hostName = "nixos";
}
