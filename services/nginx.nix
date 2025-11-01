{
  config,
  lib,
  azLib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.az.svc.nginx;
in {
  options.az.svc.nginx = with azLib.opt; {
    enable = optBool false;
    vHosts = mkOption {
      type = with types; attrsOf anything;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@${config.networking.domain}";
      defaults.webroot = "/var/lib/acme/acme-challenge/";
      certs =
        lib.mapAttrs (_: _: {
          inherit (config.services.nginx) group;
        })
        cfg.vHosts;
    };
    services.logrotate.enable = false; # https://github.com/elitak/nixos-infect/issues/205, for some reason?

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = cfg.vHosts;
    };
  };
}
