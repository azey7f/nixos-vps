{
  pkgs,
  lib,
  ...
}: {
  az.core.net.interfaces."wan" = {
    # Hetzner ARM VPS
    name = "enp1s0";
    ipv4.dhcpClient = true;
    ipv6.addr = ["2a01:4f9:c012:dc23::1"];
    ipv6.gateway = "fe80::1";
  };
  networking.hostName = "ns2";
  networking.domain = "azey.net";

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7OGEZGbudh9tNFvvzmBbOmbrePLbsoLWMqFjSmClmu"];
}
