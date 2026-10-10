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

  boot.kernelParams = [ 
    # fixes 'ath10k_pci 0000:02:00.0 AER: Error of this Agent is reported first'.
    "pcie_aspm=off"

    # fixes i915_flip hang
    "i915.enable_psr=0"
  ];
}
