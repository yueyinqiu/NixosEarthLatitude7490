{
  name,
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = name;
  text = ''
    run0 --setenv=all_proxy=socks5h://127.0.0.1:53849 nix shell nixpkgs#git -c nixos-rebuild switch --flake .
  '';
}
