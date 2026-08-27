{ config, pkgs, lib, ... }: {
  services.printing.enable = false;

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

  services.getty.autologinUser = "amrahs";
}  
