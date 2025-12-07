{
  pkgs,
  config,
  ...
}: let
  upstream = "[2a14:6f44:5608:0:25::]";
in {
  # mx-legacy.azey.net, just proxies v4 to v6
  # yes this fucks up spam filtering, no I cannot be bothered to fix it right now
  # if your mail provider doesn't have v6 you're going to spam, too bad
  systemd.services."socat" = {
    wantedBy = ["multi-user.target"];
    script = let
      proxyPort = port: let
        local = "TCP4-LISTEN:${toString port},fork,bind=95.217.221.156,su=nobody,reuseaddr";
        remote = ''"TCP6:${upstream}:${toString port}"'';
      in "${pkgs.socat}/bin/socat ${local} ${remote}";
    in ''
      ${proxyPort 25} &
      ${proxyPort 465} &
      ${proxyPort 993}
    '';
  };
  networking.firewall.allowedTCPPorts = [25 465 993];

  az.svc.nginx = {
    enable = true;
    vHosts."mta-sts.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = "mta-sts.${config.networking.domain}";
      locations."/" = {
        proxyPass = "https://${upstream}";
        extraConfig = "proxy_ssl_name mta-sts.${config.networking.domain}";
      };
    };
  };
}
