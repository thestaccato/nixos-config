# Configuration shared by both host and VM.
# Anything that differs between the two is branched on `isHost`.
{ config, pkgs, lib, currentSystemName, ... }:

let
  # True when this is our bare-metal host.
  isHost = currentSystemName == "host";
in
{
  imports = [
    ../modules/specialization/plasma.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Be careful updating this.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.sandbox = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
 
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.permittedInsecurePackages = [
  # ];

  # Define your hostname.
  networking.hostName = if isHost then "amrahs" else "dev";

  networking.networkmanager.enable = true;

  networking.firewall.enable = !isHost;

  services.resolved = {
    enable = true;
    settings.Resolve = {
      dnssec = "true";
      domains = [ "~." ];
      llmnr = "false";
      DNS = "9.9.9.9 194.242.2.2";
      FallbackDNS = "149.112.112.112 2a07:e340::2";
      DNSOverTLS = "yes";
      Cache = "yes";
      DNSStubListener = "yes";
      MulticastDNS = "no";
    };
  };
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager = {
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  }; 

  services.getty.autologinUser = "amrahs";


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    bibata-cursors
    neovim
    emacs
    helix
    git
    curl
    usbutils
    pciutils
    river
    gtk3
    gcc
    gnumake
    pkg-config
    python3
    qemu_kvm
    libvirt
    virt-manager
    tree-sitter
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_ICON_THEME = "Papirus-Dark";
    GTK_THEME = "Adwaita:dark";
    XCURSOR_THEME = "Bibata-Original-Ice";
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

  system.stateVersion = "26.05";
}
