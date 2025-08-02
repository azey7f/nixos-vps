{config, ...}: {
  az.svc.knot = {
    primaryPubkey = "uYFs8O9jjXUBuwH4MXN4mSxnc22nVsysB42lUBYGWuE=";
    # TODO: primaryAddr = "::1";
    primaryAddr = "127.0.0.1";
    primaryPort = 8853;
  };
  services.knot.settings.server = rec {
    listen = ["188.245.84.161@53" "2a01:4f8:c013:f05f::53@53"];
    listen-quic = ["188.245.84.161@853" "2a01:4f8:c013:f05f::53@853"];
    identity = config.networking.fqdn;
    nsid = identity;
  };
}
