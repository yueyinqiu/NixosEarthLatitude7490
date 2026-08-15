{ nur, ... }:
{
  users.groups.nix-daemon-proxy = { };

  systemd.services.nix-daemon-proxy-switch-server = {
    description = "nix-daemon-proxy Switch Server";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${nur.yueyinqiu.nix-daemon-proxy-server}/bin/NixDaemonProxy.Server";
      Restart = "on-failure";
      RestartSec = "5s";
      PrivateTmp = true;
      WorkingDirectory = "/tmp";
    };
  };
}
