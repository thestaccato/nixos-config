{ config, pkgs, lib, ... }: {

  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.permittedInsecurePackages = [
  # ];

  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
    river
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

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
  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-volman ];
  };
  services.gvfs.enable = true;
  programs.firefox.enable = true;
  services.upower.enable = true;
  programs.dconf.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";
}  
