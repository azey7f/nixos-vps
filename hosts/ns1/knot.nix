{config, ...}: {
  az.svc.knot = {
    primaryPubkey = "ofZVqWTsoNqYONNFpF1wOdSGWrQFcpl26Vee7F8mwY8=";
    primaryAddr = "::1";
    primaryPort = 8853;
  };
  services.knot.settings.server = rec {
    listen = ["188.245.84.161@53" "2a01:4f8:c013:f05f::53@53"];
    listen-quic = ["188.245.84.161@853" "2a01:4f8:c013:f05f::53@853"];
    identity = config.networking.fqdn;
    nsid = identity;
  };
}
