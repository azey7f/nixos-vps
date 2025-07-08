{
  config,
  lib,
  azLib,
  inputs,
  ...
}:
with lib; let
  cfg = config.az.vps.autoUpgrade;
in {
  options.az.vps.autoUpgrade = with azLib.opt; {
    enable = optBool false;
    dates = optStr "04:30";
    flake = optStr "git+https://git.${config.networking.domain}/infra/nixos-vps";
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      inherit (cfg) dates flake;
      allowReboot = true;
      randomizedDelaySec = "60min";
    };
  };
}
