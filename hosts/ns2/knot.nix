{config, ...}: {
  az.svc.knot = {
    primaryPubkey = "PYrUB63seGwBlFQQzPQCrVAGJMKJnDEekZ0XnLItQrw=";
    primaryAddr = "2a14:6f44:5608::53";
    primaryPort = 853;

    zones = [
      "azey.net"
      "8.0.6.5.4.4.f.6.4.1.a.2.ip6.arpa"
    ];
  };
  services.knot.settings.server = rec {
    listen = ["95.217.221.156@53" "2a01:4f9:c012:dc23::1@53"];
    listen-quic = ["95.217.221.156@853" "2a01:4f9:c012:dc23::1@853"];
    identity = config.networking.fqdn;
    nsid = identity;
  };
}
