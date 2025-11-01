{lib, ...}:
with lib; {
  users.users.root.hashedPassword = "*"; # needed for SSH login without PAM

  az.core = {
    hardening = {
      allowKexec = true; # installer shenanigans
      malloc = "graphene-hardened"; # VPSes have plenty of perf for proxying
      forcePTI = true;
    };

    firmware.enable = false;
    boot.loader.systemd-boot.enable = mkDefault true;

    net = {
      dns.enable = mkDefault true;
      dns.nameservers = mkDefault ["::1"];
    };
  };

  az.vps = {
    autoUpgrade.enable = true;
    disko.enable = true;
    misc.enable = true;
  };

  az.svc = {
    ssh = {
      enable = mkDefault true;
      openFirewall = mkDefault true;
      ports = mkDefault [31832];
    };
    endlessh.enable = mkDefault true;

    knot.enable = true;
    unbound.enable = true;
  };
}
