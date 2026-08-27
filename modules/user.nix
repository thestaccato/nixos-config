{ pkgs, inputs, ... }:

{
  users.users.amrahs = {
    isNormalUser = true;
    description = "amrahs";
    home = "/home/amrahs";
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
    shell = pkgs.fish; 
  };
}
