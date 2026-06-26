{ config, pkgs, ... }:

{
  # services.xserver.videoDrivers = [ "amdgpu" ];
  # services.xserver.enable = false;
  # services.xserver.displayManager.startx.enable = true;
  # services.xserver.excludePackages = [ pkgs.xterm ];
  # services.xserver.libinput.enable = true;
  # services.xserver.config = ''
  #      Section "Device"
  #        Identifier "AMD Graphics"
  #        Driver "amdgpu"
  #        BusID "PCI:05:00:0"
  #      EndSection
  #      '';
}
