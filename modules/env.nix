{ config, pkgs, lib, ... }: {
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_ICON_THEME = "Papirus-Dark";
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Bibata-Original-Ice";
    XCURSOR_SIZE = "20";
  };

  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;
}  
