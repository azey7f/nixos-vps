{
  config,
  lib,
  azLib,
  ...
}:
with lib; let
  cfg = config.az.vps.misc;
in {
  options.az.vps.misc = with azLib.opt; {
    enable = optBool false;
    tmpfs.size = optStr "2G";
  };

  config = mkIf cfg.enable {
    boot.initrd.availableKernelModules = ["xhci_pci" "sr_mod" "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
    boot.initrd.kernelModules = ["virtio_balloon" "virtio_console" "virtio_rng" "virtio_gpu"];

    fileSystems."/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=${cfg.tmpfs.size}" "mode=755"];
    };

    system.stateVersion = config.system.nixos.release; # / is on tmpfs, so this should be fine
  };
}
