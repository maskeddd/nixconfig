{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "steamdeck".id = "XTAOJ57-X3Y3AFI-JTTHST3-5GZ54U5-GCMK3VU-2P2JECQ-BG3VECY-5PTXZAS";
        "desktop".id = "TLRSZMS-WBEHDHU-FE3MLNH-Y5TW3PD-UL2KTTA-IC6KBSB-VO7LEM3-KBPUIQ4";
      };
      folders = {
        "emulation" = {
          path = "~/Emulation";
          devices = [ "steamdeck" ];
        };
      };
    };
  };
}
