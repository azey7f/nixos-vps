{config, ...}: {
  az.svc.knot = {
    primaryPubkey = "ofZVqWTsoNqYONNFpF1wOdSGWrQFcpl26Vee7F8mwY8=";
    primaryAddr = "::1";
    primaryPort = 8853;
  };
  services.knot.settings.server = rec {
    listen = ["95.217.221.156@53" "2a01:4f9:c012:dc23::53@53"];
    listen-quic = ["95.217.221.156@853" "2a01:4f9:c012:dc23::53@853"];
    identity = config.networking.fqdn;
    nsid = identity;
  };
}
