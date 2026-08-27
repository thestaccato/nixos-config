{ config, pkgs, lib, ... }: {
  security.apparmor.enable = true;

  security.rtkit.enable = true;

}
