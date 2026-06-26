{ config, pkgs, ... }:

{
  users.users.puffy = {
    isNormalUser = true;
    description = "puffy";
    extraGroups = [ "networkmanager" "wheel" "video" "libvirtd" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      adwaita-icon-theme
      mako
      foot
      cliphist
      fuzzel
      rustc
      zig
      libreoffice
      tmux
      swaybg
      hypridle
      hyprlock
      imagemagick
      waybar
      fastfetch
      gimp
      brightnessctl
      podman-compose
      zip
      unzip
      gcc
      vlc
      qemu_kvm
      libvirt
      virt-manager
      pamixer
      htop
      fzf
      kubernetes
      kubectl
      kompose
      cmatrix
      wl-clipboard
      pavucontrol
      brave
      wireshark
      zathura
      starship
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      file-roller
      qt6.qtwayland
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];
  };

  services.getty.autologinUser = "puffy";
}
