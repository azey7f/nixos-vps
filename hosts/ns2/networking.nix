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
      "2a01:4f9:c012:dc23::1/64"
      "2a01:4f9:c012:dc23::53/64"
    ];
    routes = [
      {
        Gateway = "fe80::1";
        PreferredSource = "2a01:4f9:c012:dc23::53";
      }
    ];
  };
  networking.hostName = "ns2";
  networking.domain = "azey.net";
}
