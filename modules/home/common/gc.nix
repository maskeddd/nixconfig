{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings.auto-optimise-store = true;
  };
}
