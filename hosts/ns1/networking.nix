{
  pkgs,
  lib,
  ...
}: {
  systemd.network.networks."10-wan" = {
    # Hetzner ARM VPS
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "ipv4";
    address = [
      "2a01:4f8:c013:f05f::1/64"
      "2a01:4f8:c013:f05f::53/64"
    ];
    routes = [
      {
        Gateway = "fe80::1";
        PreferredSource = "2a01:4f8:c013:f05f::53";
      }
    ];
  };
  networking.hostName = "ns1";
  networking.domain = "azey.net";
}
