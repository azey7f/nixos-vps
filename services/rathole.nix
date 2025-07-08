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
  cfg = config.az.svc.rathole;
in {
  options.az.svc.rathole = with azLib.opt; {
    enable = optBool false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443 444];
    networking.firewall.allowedUDPPorts = [443];

    environment.systemPackages = with pkgs; [unstable.rathole];

    systemd.services.rathole = {
      description = "rathole service";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${unstable.rathole}/bin/rathole /data/rathole.toml";
        Restart = "on-failure";
      };
      wantedBy = ["default.target"];
    };
  };
}
