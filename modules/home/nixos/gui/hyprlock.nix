let
  monitors = [
    "DP-2"
    "eDP-1"
  ];
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = false;
      };

      animations = {
        animation = [ "fade, 0" ];
      };

      background = {
        blur_passes = 3;
      };

      input-field = {
        monitor = monitors;
        size = "172, 36";
        outline_thickness = 0;
        fade_on_empty = false;

        placeholder_text = "Enter Password";
        swap_font_color = true;

        dots_spacing = 0.3;
        dots_center = true;

        position = "0, 150";
        halign = "center";
        valign = "bottom";
      };

      label = [
        {
          monitor = monitors;
          text = "cmd[update:60000] echo \"<span weight='600'>$(date +'%a %d %b')</span>\"";
          font_size = 25;
          font_family = "SF Pro";
          position = "0, -150";
          halign = "center";
          valign = "top";
        }
        {
          monitor = monitors;
          text = "<span weight=\"700\">$TIME</span>";
          font_size = 90;
          font_family = "SF Pro Rounded";
          position = "0, -172";
          halign = "center";
          valign = "top";
        }
      ];
    };
  };
}
