{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "vue"
      "ron"
    ];

    userSettings = {
      buffer_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";

      collaboration_panel = {
        button = false;
      };
      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };
      agent.enabled = false;

      terminal = {
        shell.program = "fish";
      };
    };
  };
}
