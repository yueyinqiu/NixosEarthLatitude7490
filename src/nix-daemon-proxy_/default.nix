{ pkgs, dotnetBuild, ... }:
let
  server = dotnetBuild.singleFile {
    name = "nix-daemon-proxy-server";
    version = "0.0.1";
    src = ./server.cs;
    nugetDeps = ./deps.nix;
  };
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nix-daemon-proxy" ''
      PROXY=$(${pkgs.jq}/bin/jq -rn --arg val "$1" '$val | @uri')
      ${pkgs.curl}/bin/curl --unix-socket /run/nix-daemon-proxy.sock -i -X POST "http://localhost/?proxy=$PROXY"
      echo 'Check with: sudo cat /proc/$(pidof nix-daemon)/environ | tr "\0" "\n" | grep proxy'
    '')
  ];

  users.groups.nix-daemon-proxy = { };

  systemd.services.nix-daemon-proxy-switch-server = {
    description = "nix-daemon-proxy Switch Server";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${server}/bin/nix-daemon-proxy-server";
      Restart = "on-failure";
      RestartSec = "5s";
      PrivateTmp = true;
      WorkingDirectory = "/tmp";
    };
  };
}
