{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    NixVirt = {
      url = "github:AshleyYakeley/NixVirt/v0.6.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      NixVirt,
      ...
    }:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          nixvirt = NixVirt;
        };
        modules = [
          ./src
        ];
      };
    };
}
