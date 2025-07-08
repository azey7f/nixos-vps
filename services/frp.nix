# TODO: sops?
{
  lib,
  azLib,
  pkgs,
  unstable,
  config,
  ...
}:
with lib; let
  cfg = config.az.svc.frp;
in {
  options.az.svc.frp = with azLib.opt; {
    enable = optBool false;
    tokenPath = optStr "/data/frp-token";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443 444];
    networking.firewall.allowedUDPPorts = [443];

    services.frp = {
      enable = true;
      role = "server";
      /*
             settings = {
             bindAddr = "::";
             bindPort = "444";
      auth.tokenSource = { #TODO: switch to nix config when this lands
        type = "file";
        file.path = cfg.tokenPath;
      };
      allowPorts = [
        # I assume this is both for TCP and UDP?
        {single = 80;}
        {single = 443;}
        {single = 853;}
      ];
      # no encryption, but the VPS is only proxying already encrypted traffic except for the :80 redirect
      # + with HSTS preload that port shouldn't really be used at all
           };
      */
    };
    systemd.services.frp.serviceConfig.ExecStart = mkForce "${pkgs.frp}/bin/frps --strict_config -c /data/frp.toml";
  };
}
