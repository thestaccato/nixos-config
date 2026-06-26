{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    usbutils
    pciutils
    river
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    inter
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "20";
  };

  programs.fish.enable = true;
  programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };
   programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.xwayland.enable = true;
  programs.thunar.enable = true;
  programs.xfconf.enable = true; 
}
