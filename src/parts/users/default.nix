{
  ...
}:
{
  users.users.yueyinqiu = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "podman"
      "libvirtd"
      "libvirt"
      "kvm"
      "nix-daemon-proxy"
    ];
  };
}
