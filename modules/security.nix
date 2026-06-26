{ config, pkgs, ... }:

{
  ###############################################
  # Linux Security Modules
  ###############################################
  security.apparmor.enable = true;

  ###############################################
  # CPU Microcode — critical for Spectre/Meltdown mitigations
  ###############################################
  hardware.cpu.amd.updateMicrocode = true;

  ###############################################
  # SSH Hardening
  ###############################################
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "puffy" ];
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      UsePAM = false;
      MaxAuthTries = 3;
      MaxSessions = 5;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      ClientAliveInterval = 300;
      ClientAliveCountMax = 0;
      AllowTcpForwarding = "no";
      X11Forwarding = false;
      AllowAgentForwarding = "no";
      PermitEmptyPasswords = false;
      LogLevel = "VERBOSE";
      Banner = null;
      KexAlgorithms = [
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group-exchange-sha256"
	"diffie-hellman-group14-sha256"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      HostKeyAlgorithms = "ssh-ed25519";
    };
    startWhenNeeded = true;
  };

  ###############################################
  # doas — minimal privilege elevation (replaces sudo)
  ###############################################
  # security.doas = {
  #   enable = true;
  #   wheelNeedsPassword = true;
  # };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults        lecture = always
      Defaults        passwd_timeout = 1
      Defaults        timestamp_timeout = 5
      Defaults        env_reset
      Defaults        mail_badpass
      Defaults        secure_path = "/run/current-system/sw/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin"
    '';
  };

  ###############################################
  # Kernel Boot Parameters
  ###############################################
  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "pti=on"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "module.sig_enforce=1"
    "quiet"
    "loglevel=0"
    "spec_store_bypass_disable=on"
    "tsx=off"
    "tsx_async_abort=full,nosmt"
    "mitigations=auto"
    "debugfs=off"
    "audit=1"
    "random.trust_cpu=off"
    "random.trust_bootloader=off"
    "amd_iommu=on"
    "lockdown=confidentiality"  # STRICTER than integrity; breaks kprobes/ftrace/perf for non-root, may affect dev tools
    # "ipv6.disable=1"           # disables IPv6 entirely; breaks apps/services that expect IPv6
    # "nosmt"                    # disables hyperthreading; mitigates SMT side-channels but halves multi-thread perf
  ];

  ###############################################
  # Sysctl Hardening
  ###############################################
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.kexec_load_disabled" = 1;
    "kernel.yama.ptrace_scope" = 2;
    "kernel.sysrq" = 0;
    "kernel.perf_event_paranoid" = 3;
    "kernel.randomize_va_space" = 2;
    "kernel.ftrace_enabled" = false;

    # "kernel.hidepid" = 2;           # hides other users' processes; breaks `ps aux` / `top` for non-root users

    "kernel.core_pattern" = "/dev/null";
    "dev.tty.ldisc_autoload" = 0;
    "net.core.bpf_jit_kallsyms" = 0;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;

    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.protected_fifos" = 2;
    "fs.suid_dumpable" = 0;

    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;

    # "vm.unprivileged_userfaultfd" = 0;       # breaks QEMU post-copy migration, Wine/Proton page fault handling
    # "kernel.io_uring_disabled" = 2;          # breaks apps using modern async I/O (databases, web servers, Nix daemon)
    # "net.ipv4.tcp_fastopen" = 0;             # privacy: prevents TCP Fast Open (leaks timing info); breaks perf on some sites
    # "kernel.unprivileged_userns_clone" = 0;  # breaks podman/libvirtd — uncomment only if you don't use containers
  };

  ###############################################
  # Firewall
  ###############################################
  networking.firewall = {
    rejectPackets = false;
    logRefusedConnections = true;
    logReversePathDrops = true;
    allowPing = false;
    checkReversePath = "strict";
  };

  ###############################################
  # DNS Privacy & Security
  ###############################################
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
  # networking.networkmanager.insertNameservers = [ "1.1.1.1" "9.9.9.9" ];

  ###############################################
  # Network Privacy (MAC randomization)
  ###############################################
  networking.networkmanager = {
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  ###############################################
  # Core Dumps — disabled at kernel level
  ###############################################
  systemd.coredump.enable = false;
  # kernel.core_pattern = "/dev/null" is set in sysctl above

  ###############################################
  # Clean /tmp on boot
  ###############################################
  boot.tmp.cleanOnBoot = true;

  ###############################################
  # SSD fstrim
  ###############################################
  services.fstrim.enable = true;

  ###############################################
  # Disable GeoLocation
  ###############################################
  services.geoclue2.enable = false;

  ###############################################
  # Disable mDNS / Avahi (commented if needed)
  ###############################################
  services.avahi.enable = false;

  ###############################################
  # Journald — limit log size
  ###############################################
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=1month
  '';

  ###############################################
  # dbus-broker — more auditable than dbus-daemon
  ###############################################
  services.dbus.implementation = "broker";

  ###############################################
  # Bootloader — limit old generations shown
  ###############################################
  boot.loader.systemd-boot.configurationLimit = 10;

  ###############################################
  # Block known telemetry hosts
  ###############################################
  networking.extraHosts = ''
    0.0.0.0     telemetry.mozilla.org
    0.0.0.0     incoming.telemetry.mozilla.org
    0.0.0.0     telemetry.microsoft.com
    0.0.0.0     vortex.data.microsoft.com
    0.0.0.0     settings-win.data.microsoft.com
    0.0.0.0     watson.telemetry.microsoft.com
    ::0         telemetry.mozilla.org
    ::0         incoming.telemetry.mozilla.org
    ::0         telemetry.microsoft.com
    ::0         vortex.data.microsoft.com
    ::0         settings-win.data.microsoft.com
    ::0         watson.telemetry.microsoft.com
  '';

  ###############################################
  # Brute-force & DoS Protection
  ###############################################
  services.fail2ban.enable = true;
  services.earlyoom.enable = true;

  ###############################################
  # USB Device Control
  ###############################################
  #services.usbguard.enable = true;

  ###############################################
  # System Audit Logging
  ###############################################
  # security.auditd.enable = true;
  # security.audit.enable = true;
  # security.audit.backlogLimit = 8192;
  # security.audit.failureMode = "printk";
  # security.audit.rateLimit = 0;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];


  ###############################################
  # Automatic Updates
  ###############################################
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    randomizedDelaySec = "45min";
    allowReboot = false;
  };

  ###############################################
  # Nix Hardening — restrict who can use Nix
  ###############################################
  nix.settings = {
    allowed-users = [ "puffy" ];
    trusted-users = [ "puffy" ];
  };

  ###############################################
  # PAM Resource Limits (RLIMIT) — DoS prevention
  ###############################################
  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nproc"; value = "1000";   }
    { domain = "*"; type = "hard"; item = "nproc"; value = "2000";   }
    { domain = "*"; type = "soft"; item = "nofile"; value = "4096";  }
    { domain = "*"; type = "hard"; item = "nofile"; value = "8192";  }
    { domain = "*"; type = "soft"; item = "memlock"; value = "65536"; }
    { domain = "*"; type = "hard"; item = "memlock"; value = "131072";}
  ];

  ###############################################
  # logind — kill user processes on logout
  ###############################################
  services.logind.settings.Login = {
    KillUserProcesses= true;
    KillOnlyUsers="puffy";
    IdleAction="lock";
    IdleActionSec= "15min";
  };

  ###############################################
  # Blacklist unused kernel modules
  ###############################################
  boot.blacklistedKernelModules = [
    "firewire_ohci" "firewire_core" "firewire_sbp2"
    "can" "cifs" "nfs" "nfsd" "rds" "tipc"
    "dccp" "sctp" "r820t" "uvcvideo"
  ];

  ###############################################
  # Kernel Integrity Lockdown
  ###############################################
  security.protectKernelImage = true;

  ###############################################
  # OPT-IN: Extras that may break things
  # Uncomment only after verifying compatibility
  ###############################################

  # services.fwupd.enable = false;
  #   Disables the firmware update daemon (phones home to LVFS).
  #   Security trade-off: prevents auto firmware updates but improves privacy.
  #   Only disable if you manually check for firmware updates.

  # security.lockKernelModules = true;
  #   Prevents loading/unloading kernel modules after boot.
  #   Breaks: hotplug devices (USB, external drives), VirtualBox additions, etc.
  #   KVM modules loaded via initrd are unaffected.

  # security.allowUserNamespaces = false;
  #   Disables user namespaces entirely.
  #   Breaks: podman, Docker, libvirtd, bubblewrap (flatpak/snap),
  #   Chrome/Firefox sandboxing.

  # programs.tor.client.enable = true;
  #   Routes all traffic through Tor.
  #   Heavy latency impact, many sites block Tor exit nodes,
  #   incompatible with some streaming/dev workflows.

  # services.opensnitch.enable = true;
  #   Application-level outbound firewall (GUI).
  #   High user interaction overhead — every new connection prompts.
  #   Requires userspace daemon + GUI service.

  # services.clamav.daemon.enable = true;
  #   On-access antivirus scanner.
  #   Significant CPU/RAM overhead on a NixOS desktop,
  #   limited value since packages are built from source with hashes.

  # security.apparmor.killUnconfinedConfinables = true;
  #   Kills any process without an AppArmor profile.
  #   Breaks: nearly everything — NixOS does not ship AppArmor profiles
  #   for most packages. Only enable with custom profiles.

  # nix.settings.auto-optimise-store = true;
  #   Deduplicates /nix/store by hardlinking identical files.
  #   High CPU/RAM during GC,
  #   may slow down builds. Privacy benefit: harder to distinguish store paths.

  # boot.loader.systemd-boot.configurationLimit = 5;
  #   Limits boot entries — lowers the limit from the default 10 above.

  # systemd.enableEmergencyMode = false;
  #   Disables emergency mode rescue shell.
  #   If a critical service fails, systemd drops to emergency shell.
  #   Disabling prevents interactive recovery via console.

  # services.udisks2.enable = false;
  #   Disables the udisks2 daemon for automounting removable drives.
  #   Breaks: automatic USB/optical drive mounting in file managers.
  #   Manual mount via `mount` still works.

  # services.nscd.enable = false;
  #   Disables nscd (Name Service Cache Daemon).
  #   systemd-resolved handles caching better.
  #   Breaks: legacy apps that rely on nscd for host lookups.

  # security.virtualisation.flushL1DataCache = "always";
  #   Flushes L1 data cache on VM entry/exit.
  #   Only meaningful if running untrusted VMs.
  #   Performance impact on VM workloads.

  # security.allowReintro = false;
  #   Prevents reintroduction of ambient capabilities on logout.
  #   Very minor hardening — only matters for per-account capabilities.

  # environment.memoryAllocator.provider = "scudo";
  #   Replaces glibc malloc with LLVM Scudo hardened allocator.
  #   Protects against heap overflows, use-after-free, double-free.
  #   Breaks: some software with custom allocators or specific memory requirements.

   environment.memoryAllocator.provider = "graphene-hardened";
  #   GrapheneOS hardened_malloc — stricter than Scudo.
  #   Breaks: more software than Scudo; test thoroughly.

  # users.mutableUsers = false;
  #   Prevents runtime user/group changes (useradd, usermod, passwd).
  #   All user management becomes purely declarative via Nix config.
  #   Breaks: any imperative user management or auto-provisioning tools.
}
