{ config, pkgs, lib, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];
}  
