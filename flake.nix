{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    NixVirt = {
      url = "github:AshleyYakeley/NixVirt/v0.6.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-daemon-proxy.url = "github:yueyinqiu/NixDaemonProxy-Nix";
  };

  outputs = inputs: {
    nixosConfigurations.earth-latitude7490 =
      let
        system = "x86_64-linux";
      in
      inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          nixvirt = inputs.NixVirt;
          nur = inputs.nur.legacyPackages.${system}.repos;
        };
        modules = [
          inputs.nix-daemon-proxy.nixosModules.nix-daemon-proxy
          ./src
        ];
      };

    devShells = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system: {
      default = import ./dev {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    });
  };
}
