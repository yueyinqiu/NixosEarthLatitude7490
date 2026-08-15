{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    NixVirt = {
      url = "github:AshleyYakeley/NixVirt/v0.6.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    };
  };

  outputs =
    {
      input,
      ...
    }:
    {
      nixosConfigurations.earth-latitude7490 =
        let
          system = "x86_64-linux";
        in
        input.nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            nixvirt = input.NixVirt;
            nur = input.nur.legacyPackages.${system}.repos;
          };
          modules = [
            ./src
          ];
        };

      devShells = input.nixpkgs.lib.genAttrs input.nixpkgs.lib.systems.flakeExposed (
        system:
        let
          pkgs = input.nixpkgs.legacyPackages.${system};
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
