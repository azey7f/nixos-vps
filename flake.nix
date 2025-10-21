{
  inputs = {
    self.submodules = true;
    core.url = "./core";
  };

  outputs = {
    self,
    core,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in rec {
    inherit (core.outputs) formatter;

    nixosConfigurations = core.mkHostConfigurations {
      path = ./hosts;
      system = "aarch64-linux";

      modules = [
        ./config
        ./services
        ./preset.nix
      ];
    };
  };
}
