{
  config,
  lib,
  azLib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.az.svc.gatus;
in {
  options.az.svc.gatus = with azLib.opt; {
    enable = optBool false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    az.svc.nginx.enable = true;
    az.svc.nginx.vHosts."status.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = "status.${config.networking.domain}";

      locations."/".proxyPass = "http://[::1]:8080/";
      locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
    };

    services.gatus = {
      enable = true;
      settings = {
        web.port = 8080;
        endpoints =
          builtins.map (sub: {
            name = "${sub}${config.networking.domain}";
            url = "https://${sub}${config.networking.domain}";
            interval = "30s";
            conditions = [
              "[STATUS] == 200"
              "[RESPONSE_TIME] < 10000"
            ];
          }) [
            # TODO: dynamically generate?
            ""
            "git."
            "search."
          ];
      };
    };
  };
}
