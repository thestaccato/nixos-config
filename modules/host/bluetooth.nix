{ config, pkgs, lib, ... }: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
}  
