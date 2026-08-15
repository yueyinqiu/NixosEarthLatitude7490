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
      nixosConfigurations.earth-latitude7490 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          nixvirt = NixVirt;
        };
        modules = [
          ./src
        ];
      };

      devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              (pkgs.writeShellScriptBin "dev-switch-local-proxy" ''
                ssh localhost -t "cd '$PWD' && sudo all_proxy=socks5h://127.0.0.1:26290 nixos-rebuild switch --flake ."
              '')
            ];
          };
        }
      );
    };
}
