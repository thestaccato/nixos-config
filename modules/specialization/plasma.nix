# KDE Plasma (Wayland)
{ pkgs, ... }: {
  specialisation.plasma.configuration = {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
