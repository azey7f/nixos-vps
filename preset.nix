{lib, ...}:
with lib; {
  az.core = {
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
    ssh.enable = mkDefault true;
    ssh.openFirewall = mkDefault true;
    ssh.ports = mkDefault [31832];
    endlessh.enable = mkDefault true;

    knot.enable = true;
    unbound.enable = true;
    #rathole.enable = true; # for some reason I couldn't get rathole to work in K8s, always crashed when trying to start the config watcher
    frp.enable = true;
  };
}
