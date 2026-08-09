# VM. This runs under KVM/QEMU on the bare-metal host.
# It is meant to be managed through virt-manager (or virsh) with virtio
# devices.
{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    ./hardware/vm.nix
    ./vm-shared.nix
  ];
  
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda"; 
  };

  # Network interface for a virtio NIC in QEMU/KVM. If `ip link` shows a
  # different name (e.g. enp6s0), adjust this.
  networking.interfaces.enp1s0.useDHCP = true;

  # QEMU guest agent: tells the host (libvirt) the guest's IP, etc.
  services.qemuGuest.enable = true;

  # Spice agent: clipboard sharing, display resizing, drag & drop.
  services.spice-vdagentd.enable = true;

  # SPICE WebDAV: shared folders between host and guest.
  services.spice-webdavd.enable = true;
}
