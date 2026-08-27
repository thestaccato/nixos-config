{ config, pkgs, lib, ... }: {

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.extraConfig = ''
    unix_sock_group = "libvirtd"
    unix_sock_rw_perms = "0770"
  '';
  
  virtualisation.containers.enable = true;
    virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    libvirt 
    qemu_kvm
  ];
}
