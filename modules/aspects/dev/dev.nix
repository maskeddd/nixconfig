{
  den.aspects.dev = {
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        home.packages = with pkgs; [
          typst
          nixd
          nixfmt
          nil
          claude-code
        ];

        home.file."${config.programs.pi-coding-agent.configDir}/claude-bridge.json".text = builtins.toJSON {
          askClaude.enabled = false;
          provider = {
            plan = "pro";
            longContextExtraUsage = false;
            strictMcpConfig = true;
            pathToClaudeCodeExecutable = "${pkgs.claude-code}/bin/claude";
          };
        };

        home.file."${config.programs.pi-coding-agent.configDir}/mcp.json" =
          lib.mkIf (config.programs.mcp.enable && config.programs.mcp.servers != { })
            {
              source = config.xdg.configFile."mcp/mcp.json".source;
            };

        programs = {
          mcp = {
            enable = true;
          };

          pi-coding-agent = {
            enable = true;
            extraPackages = [ pkgs.nodejs ];
            settings = {
              packages = [
                "npm:pi-claude-bridge@0.9.2"
                "npm:pi-web-access"
                "npm:@juicesharp/rpiv-ask-user-question"
                "npm:@juicesharp/rpiv-todo"
                "npm:pi-lens"
                "npm:pi-subagents"
              ];

              enabledModels = [
                "openai/gpt-6.1-sol"
                "openai/gpt-6-astra"
                "claude-bridge/claude-opus-5-5"
              ];
            };
          };

          lazygit.enable = true;
          devenv.enable = true;
        };
      };

    hmLinux =
      { pkgs, lib, ... }:
      {
        home.packages = with pkgs; [
          (buildFHSEnv {
            name = "rider-fhs";
            executableName = "rider";
            targetPkgs =
              fhsPkgs: with fhsPkgs; [
                jetbrains.rider
                dotnetCorePackages.sdk_10_0
              ];
            runScript = lib.getExe jetbrains.rider;
            extraInstallCommands = ''
              mkdir -p $out/share
              ln -s ${jetbrains.rider}/share/applications $out/share/applications
              ln -s ${jetbrains.rider}/share/icons $out/share/icons
            '';
          })
        ];
      };

    hmDarwin =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.jetbrains.rider ];
      };
  };
}
