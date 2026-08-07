{
  den.aspects.ghostty = {
    homeManager =
      { pkgs, ... }:
      {
        programs.ghostty = {
          enable = true;
          settings = {
            command = "${pkgs.fish}/bin/fish";
            focus-follows-mouse = true;
            keybind =
              let
                leader = "ctrl+g";
              in
              [
                "${leader}>v=new_split:right"
                "${leader}>s=new_split:down"

                "${leader}>h=goto_split:left"
                "${leader}>j=goto_split:down"
                "${leader}>k=goto_split:up"
                "${leader}>l=goto_split:right"

                "${leader}>x=close_surface"
                "${leader}>z=toggle_split_zoom"
                "${leader}>e=equalize_splits"

                "${leader}>t=new_tab"
                "${leader}>n=next_tab"
                "${leader}>p=previous_tab"
                "${leader}>r=prompt_tab_title"

                "${leader}>shift+h=resize_split:left,10"
                "${leader}>shift+j=resize_split:down,10"
                "${leader}>shift+k=resize_split:up,10"
                "${leader}>shift+l=resize_split:right,10"

                "${leader}>ctrl+g=text:\\x07"
              ];
            macos-titlebar-style = "hidden";
          };
        };
      };

    hmDarwin =
      { pkgs, ... }:
      {
        programs.ghostty.package = pkgs.ghostty-bin;
      };
  };
}
