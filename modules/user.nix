{ pkgs, ... }:

{
  users.users.amrahs = {
    isNormalUser = true;
    home = "/home/amrahs";
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
    shell = pkgs.fish; 
  };
}
