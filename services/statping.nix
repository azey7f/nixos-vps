{
  config,
  lib,
  azLib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.az.svc.statping;
in {
  options.az.svc.statping = with azLib.opt; {
    enable = optBool false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];
    systemd.services.statping-ng = {
      description = "Statping Server";
      requires = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment = {
        NAME = "azey.net";
        DESCRIPTION = "uptime stats of important services";
        DOMAIN = "https://status.${config.networking.domain}";

        DB_CONN = "sqlite";
        DISABLE_LOGS = "true";

        LETSENCRYPT_ENABLE = "true";
        LETSENCRYPT_HOST = "status.${config.networking.domain}";
        LETSENCRYPT_EMAIL = "admin@${config.networking.domain}";
      };

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.statping-ng}/bin/statping-ng";
        WorkingDirectory = "/data/statping";
        EnvironmentFile = "/data/statping/env";
      };
    };
  };
}
