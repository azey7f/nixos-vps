{config, ...}: {
  az.svc.knot = {
    primaryPubkey = "cdWcAXlvEPBvMa1QmLOXz/THBhmnYs25rzZ2GiLGuvQ=";
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
