{
  pkgs,
  nixvirt,
  ...
}:
{
  imports = [
    nixvirt.nixosModules.default
  ];

  virtualisation.libvirt.enable = true;
  virtualisation.libvirt.package = pkgs.libvirt;
  
  virtualisation = {
    libvirtd = {
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
  virtualisation.libvirt.connections."qemu:///system".networks = [
    {
      definition = nixvirt.lib.network.writeXML (
        nixvirt.lib.network.templates.bridge {
          uuid = "c035e1de-ee53-416a-b4c9-508fa48f4111";
          subnet_byte = 71;
        }
      );
      active = true;
    }
  ];
}
