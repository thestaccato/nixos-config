# NixOS VM configuration.
{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    ./hardware/vm.nix
    ./vm-shared.nix
  ];

  services.qemuGuest.enable = true;

  services.spice-vdagentd.enable = true;

  services.spice-webdavd.enable = true;

  networking.interfaces.enp2s0.useDHCP = true;

  networking.firewall.enable = true;

  networking.hostName = "nixos-vm";
}
