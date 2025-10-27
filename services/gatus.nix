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

    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@${config.networking.domain}";
      defaults.webroot = "/var/lib/acme/acme-challenge/";
      certs."status.${config.networking.domain}".group = config.services.nginx.group;
    };
    services.logrotate.enable = false; # https://github.com/elitak/nixos-infect/issues/205, for some reason?

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."status.${config.networking.domain}" = {
        forceSSL = true;
        useACMEHost = "status.${config.networking.domain}";

        locations."/".proxyPass = "http://[::1]:8080/";
        locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
      };
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
              "[RESPONSE_TIME] < 1000"
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
