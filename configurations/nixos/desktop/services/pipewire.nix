{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."10-link-max-buffers" = {
      "context.properties" = {
        "link.max-buffers" = 64;
      };
    };
  };
}
