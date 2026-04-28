{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
      {
        libraries = with pkgs.python3Packages; [
          capstone
          pyelftools
        ];
        flakeIgnore = [
          "E501"
          "F403"
          "F405"
        ];
      }
      (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/sersorrel/sys/afc85e6b249e5cd86a7bcf001b544019091b928c/hm/discord/krisp-patcher.py";
            sha256 = "sha256-h8Jjd9ZQBjtO3xbnYuxUsDctGEMFUB5hzR/QOQ71j/E=";
          }
        )
      );
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  home.activation.krispPatcher = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    shopt -s nullglob
    nodes=("$HOME"/.config/discord/*/modules/discord_krisp/discord_krisp.node)
    shopt -u nullglob

    if [ ''${#nodes[@]} -eq 0 ]; then
      $VERBOSE_ECHO "krisp-patcher: no discord_krisp.node found, skipping"
    else
      for node in "''${nodes[@]}"; do
        $VERBOSE_ECHO "krisp-patcher: patching $node"
        $DRY_RUN_CMD ${krisp-patcher}/bin/krisp-patcher "$node" || true
      done
    fi
  '';

  programs.nixcord = {
    enable = true;
    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/flavors/midnight-nord.theme.css"
      ];
      plugins = {
        anonymiseFileNames.enable = true;
        betterGifPicker.enable = true;
        ClearURLs.enable = true;
        memberCount.enable = true;
        messageLogger.enable = true;
        spotifyControls.enable = true;
        silentTyping.enable = true;
        gameActivityToggle.enable = true;
      };
    };
  };
}
