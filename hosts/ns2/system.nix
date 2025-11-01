{config, ...}: let
  cloneDir = "/data/${config.networking.domain}";
in {
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7OGEZGbudh9tNFvvzmBbOmbrePLbsoLWMqFjSmClmu"];

  #az.svc.statping.enable = true;
  az.svc.gatus.enable = true;
  az.svc.nginx = {
    enable = true;
    vHosts."v4.${config.networking.domain}" = {
      forceSSL = true;
      useACMEHost = "v4.${config.networking.domain}";

      root = "${cloneDir}/static";

      extraConfig = ''
        rewrite ^(?<path>.*)/__autoindex\.json$	$path/			last;
        rewrite ^(?<path>.*)/$			$path/index.html	last;

        autoindex on;
        autoindex_exact_size on;
        autoindex_format json;

        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header Referrer-Policy 'same-origin' always;
        add_header 'Access-Control-Allow-Origin' '*' always;

        add_header Cross-Origin-Opener-Policy 'same-origin' always;
        add_header Cross-Origin-Embedder-Policy 'require-corp' always;

        add_header Content-Security-Policy "upgrade-insecure-requests; base-uri 'self'; connect-src 'self'; default-src 'none'; font-src 'self'; form-action 'self'; frame-ancestors 'self'; img-src 'self' data: blob:; manifest-src 'self'; media-src 'self'; script-src 'self' blob:; style-src 'self'; worker-src 'self' blob:;" always;
        add_header Permissions-Policy 'accelerometer=(), ambient-light-sensor=(), autoplay=(self), battery=(), camera=(), clipboard-read=(), clipboard-write=(self), conversion-measurement=(), cross-origin-isolated=(), display-capture=(), document-domain=(), encrypted-media=(), execution-while-not-rendered=(), execution-while-out-of-viewport=(), focus-without-user-activation=(), fullscreen=(self), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), navigation-override=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), serial=(), speaker-selection=(), sync-script=(), sync-xhr=(), trust-token-redemption=(), unload=(), usb=(), vertical-scroll=(), web-share=(), window-placement=(), xr-spatial-tracking=()' always;
      '';

      locations."/".index = "________________none";
      locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = ["*/5 * * * *  root  git -C ${cloneDir} fetch && git -C ${cloneDir} reset --hard origin/main"];
  };
}
