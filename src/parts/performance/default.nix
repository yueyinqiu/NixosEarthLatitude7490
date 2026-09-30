{
  ...
}:
{
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;
  boot.zswap.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      options = [ "discard" ];
    }
  ];

  # To fix 'ath10k_pci 0000:02:00.0 AER: Error of this Agent is reported first'.
  # Not sure whether it really works or not.
  boot.kernelParams = [ "pcie_aspm=off" ];
}
